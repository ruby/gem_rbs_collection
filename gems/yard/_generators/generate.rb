require 'orthoses-yard'
require 'fileutils'
require 'pathname'
require 'erb'

stdlib_dependencies = %w[
  optparse
  logger
  ripper
]

output_dir = 'out'
Orthoses.logger.level = :warn

gem_path = Gem::Specification.find_by_name("yard").load_paths.first
notice = "# !!! GENERATED FILE !!!\n# Please see generators/yard-generator/README.md\n"

Orthoses::Builder.new do
  use Orthoses::CreateFileByName,
    depth: 2,
    to: output_dir,
    header: notice,
    rmtree: true
  use Orthoses::Filter do |name, content|
    name.start_with?('YARD') ||
      name.start_with?('SymbolHash')
  end
  use Orthoses::LoadRBS,
    paths: Dir.glob("known_sig/**/*.rbs")
  use Orthoses::Tap do |store|
    # remove rack dependency
    store['YARD::Server::Commands::Base'].delete("# @return [Rack::Request] request object\nattr_accessor request: Rack::Request")
    # FIXME: YARD's issue?
    store['YARD::CLI::YardocOptions'].delete("# @return [Numeric] An index value for rendering sequentially related templates\nattr_accessor index: Numeric")
  end
  use Orthoses::YARD,
    parse: [
      "#{gem_path}/**/*.rb",
    ],
    log_level: :warn,
    allow_empty_doc: true
  use Orthoses::Autoload
  run -> {
    require 'yard'
    require "yard/i18n/po_parser"
    YARD::Tags::Library.define_tag("YARD Tag Signature", 'yard.signature'.to_sym, nil)
    YARD::Tags::Library.define_tag("YARD Tag", 'yard.tag'.to_sym, :with_types_and_name)
    YARD::Tags::Library.define_tag("YARD Directive", 'yard.directive'.to_sym, :with_types_and_name)
  }
end.call

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
