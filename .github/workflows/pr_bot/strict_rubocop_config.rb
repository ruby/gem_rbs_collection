# frozen_string_literal: true

# This script checks the .rubocop.yml files in the repository.
#
# RuboCop may execute arbitrary code in the .rubocop.yml file.
# For example:
#   * RuboCop allows ERB in the .rubocop.yml file.
#   * RuboCop can load Ruby files with `require`.
#
# It causes a security risk. This repository allows anyone to modify any file.
# So, an attacker can inject malicious code into the .rubocop.yml file.
# The contributors may execute the malicious code by running `rubocop` command.
#
# To avoid this problem, this script checks the .rubocop.yml file.
# It only allows `inherit_from` and configuring `RBS` related cops.

require 'open3'
require 'yaml'

DISALLOWED_CHARACTERS_RE = /[^a-zA-Z0-9\s_\/#:'".,\-]/

class InvalidCharacters < StandardError
  def initialize(path:, match:)
    @path = path
    @match = match
    super message
  end

  def message
    <<~MSG
      Invalid characters in #{@path}:#{lineno}:#{column}.
      #{highlight}
    MSG
  end

  private

  attr_reader :path, :match

  def highlight
    line = match.pre_match.lines.last + match[0] + match.post_match.lines.first
    line + ' ' * (column-1) + '^'
  end

  def lineno
    match.pre_match.count("\n") + 1
  end

  def column
    match.pre_match.lines.last.size + 1
  end
end

class InvalidFormat < StandardError
  def initialize
    super <<~MSG
      This .rubocop.yml file is not formatted correctly.
      It only allows `inherit_from` and configuring `RBS` related cops.
    MSG
  end
end

def validate_rubocop_yml!(path)
  config_str = File.read(path)
  if match = config_str.match(DISALLOWED_CHARACTERS_RE)
    raise InvalidCharacters.new(path:, match:)
  end

  obj = YAML.safe_load(config_str)
  raise InvalidFormat unless obj.is_a?(Hash)

  obj.each do |key, value|
    case key
    when 'inherit_from'
      raise InvalidFormat unless value == '../../.rubocop.yml'
    when 'RBS', %r!\ARBS/[/\w]+!
      # noop
    else
      raise InvalidFormat
    end
  end
end

out, st = Open3.capture2('git', 'ls-files', '-z')
unless st.success?
  raise "Failed to run `git ls-files -z`"
end

out.split("\0").each do |file|
  # Allow the top-level .rubocop.yml
  next if file == '.rubocop.yml'

  next unless File.basename(file) == '.rubocop.yml'

  validate_rubocop_yml!(file)
end

# ----------------------------------------
# Test
# ----------------------------------------
return unless ENV['RUN_TEST']

require 'tempfile'

def with_tempfile(content)
  Tempfile.open do |f|
    f.write(content)
    f.close
    yield f.path
  end
end

def good(yaml)
  with_tempfile(yaml) do |path|
    validate_rubocop_yml!(path)
  end
end

def bad(yaml, expected:)
  with_tempfile(yaml) do |path|
    validate_rubocop_yml!(path)
  end
rescue expected
  # ok
else
  raise "Expected to raise InvalidFormat or InvalidCharacters"
end

good(<<~YAML)
  inherit_from: ../../.rubocop.yml
YAML

good(<<~YAML)
  inherit_from: ../../.rubocop.yml
  RBS:
    Enabled: true
  RBS/Style:
    Enabled: true
  RBS/Lint/AmbiguousOperatorPrecedence:
    Enabled: true
YAML

bad(<<~YAML, expected: InvalidCharacters)
  # <% hello %>
  inherit_from: ../../.rubocop.yml
YAML

bad(<<~YAML, expected: InvalidFormat)
  require: test.rb
YAML
