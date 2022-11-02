require 'orthoses-yard'
require 'fileutils'
require 'pathname'
require 'erb'

output_dir = '../../gems/yard/0.9'
FileUtils.rm_rf(output_dir)
Orthoses.logger.level = :warn

gem_path = Gem::Specification.find_by_name("yard").load_paths.first
notice = "# !!! GENERATED FILE !!!\n# Please see generators/yard-generator/README.md\n"

Orthoses::Builder.new do
  use Orthoses::CreateFileByName,
    base_dir: output_dir,
    header: notice
  use Orthoses::Filter do |name, content|
    name.start_with?('YARD') ||
      name.start_with?('Ripper') ||
      name.start_with?('OpenStruct') ||
      name.start_with?('SymbolHash') ||
      name.start_with?('Rake') ||
      name.start_with?('WEBrick') ||
      name.start_with?('RDoc')
  end
  use Orthoses::Tap do |store|
    store['YARD'].header = 'module YARD'
    store['YARD::CodeObjects'].header = 'module YARD::CodeObjects'
    store['YARD::Handlers'].header = 'module YARD::Handlers'
    store['YARD::Handlers::C'].header = 'module YARD::Handlers::C'
    store['YARD::Handlers::Common'].header = 'module YARD::Handlers::Common'
    store['YARD::Handlers::Ruby'].header = 'module YARD::Handlers::Ruby'
    # TODO: support generics
    store['YARD::Tags::Library'] << 'def self.labels: () -> SymbolHash'

    # FIXME: YARD's issue?
    store['YARD::CLI::YardocOptions'].delete("# @return [Numeric] An index value for rendering sequentially related templates\nattr_accessor index: Numeric")
  end
  use Orthoses::YARD,
    parse: [
      "#{gem_path}/yard.rb",
      "#{gem_path}/yard/**/*.rb",
    ]
  use Orthoses::Autoload
  run -> {
    require 'yard'
    YARD::Tags::Library.define_tag("YARD Tag Signature", 'yard.signature'.to_sym, nil)
    YARD::Tags::Library.define_tag("YARD Tag", 'yard.tag'.to_sym, :with_types_and_name)
    YARD::Tags::Library.define_tag("YARD Directive", 'yard.directive'.to_sym, :with_types_and_name)
  }
end.call

stdlib_dependencies = %w[
  set
  optparse
  logger
  monitor
]

def erb(template_filename, **vars)
  "templates/#{template_filename}.erb"
    .then { File.expand_path(_1) }
    .then { File.read(_1) }
    .then { ERB.new(_1, trim_mode: '<>').result_with_hash(vars) }
end

out = Pathname(output_dir)
out.join("EXTERNAL_TODO.rbs").write(erb("EXTERNAL_TODO.rbs", notice: notice))
out.join("manifest.yaml").write(erb("manifest.yaml", notice: notice, stdlib_dependencies: stdlib_dependencies))
out.join('_scripts').tap do |scripts|
  scripts.mkpath
  scripts.join("test").tap do |test|
    test.write(erb("_scripts/test", notice: notice, stdlib_dependencies: stdlib_dependencies))
    test.chmod(0o755)
  end
end
out.join('_test').tap do |test|
  test.mkpath
  test.join("yard.rb").write(erb("_test/yard.rb", notice: notice))
  test.join('Steepfile').write(erb("_test/Steepfile", notice: notice, stdlib_dependencies: stdlib_dependencies))
end
