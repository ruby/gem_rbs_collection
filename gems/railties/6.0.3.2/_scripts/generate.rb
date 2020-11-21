# Usage
#
#   ruby generate.rb all
#   ruby generate.rb actionpack

require 'bundler/inline'

require 'pathname'
require 'open3'

RAILS_CODE_DIR = Pathname(__dir__) / '../_src/'

def bin(c)
  Pathname(__dir__).join('../_rbs_rails/bin/', c).to_s
end

def sh!(*cmd, **kwargs)
  puts(cmd.join(' '))
  Open3.capture2(*cmd, **kwargs).then do |out, status|
    raise unless status.success?

    out
  end
end

def patch!(name, rbs)
  case name
  when 'actionpack'
    rbs.gsub!(/(      def _reduce_\d+: \(untyped val, untyped _values\) -> )([A-Z]\w*)/) do
      "#{$~[1]}Nodes::#{$~[2]}"
    end || raise('it looks unnecessary.')

    # XXX: I guess add-type-params.rb resolves this
    rbs.gsub!('-> Parameter', '-> Parameter[untyped]') || raise('it looks unnecessary')
  when 'railties'
    rbs.gsub!(
      'class NonSymbolAccessDeprecatedHash < HashWithIndifferentAccess',
      'class NonSymbolAccessDeprecatedHash[T, U] < HashWithIndifferentAccess[T, U]')
    # XXX: I guess add-type-params.rb resolves this
    rbs.gsub!(
      'def middleware: () -> Hash',
      'def middleware: () -> Hash[untyped, untyped]')
    # XXX: I guess add-type-params.rb resolves this
    rbs.gsub!(
      'def +: (untyped other) -> Collection',
      'def +: (untyped other) -> Collection[untyped]')
    # XXX: I guess add-type-params.rb resolves this
    rbs.gsub!(
      'def initializers_for: (untyped binding) -> Collection',
      'def initializers_for: (untyped binding) -> Collection[untyped]')
  when 'activesupport'
    rbs.gsub!(
      /^  include Java$/,
      '  # include Java # Java module is missing')
    # XXX: I guess add-type-params.rb resolves this
    rbs.gsub!(
      'class Configuration < ActiveSupport::InheritableOptions',
      'class Configuration[T, U] < ActiveSupport::InheritableOptions[T, U]')
    # XXX: I guess add-type-params.rb resolves this
    rbs.gsub!(
      'class InheritableOptions < OrderedOptions',
      'class InheritableOptions[T, U] < OrderedOptions[T, U]')
    rbs.gsub!( # ref: 5c507aaae492ff5b2002fdd3ece2044b283b5d6f
      'include ActiveSupport::Logger::Severity',
      'include ::Logger::Severity')
    # XXX: I guess add-type-params.rb resolves this
    rbs.gsub!(
      'def with_indifferent_access: () -> ActiveSupport::HashWithIndifferentAccess',
      'def with_indifferent_access: () -> ActiveSupport::HashWithIndifferentAccess[K, V]')
    # XXX: I guess add-type-params.rb resolves this
    rbs.gsub!(
      'def inquiry: () -> ActiveSupport::ArrayInquirer',
      'def inquiry: () -> ActiveSupport::ArrayInquirer[Elem]')

    # These aliases are actually defined, but it causes duplicated method definition
    rbs.gsub!('alias to_s to_formatted_s', '')
    rbs.gsub!('alias + plus_with_duration', '')
    rbs.gsub!('alias - minus_with_duration', '')
    rbs.gsub!('alias - minus_with_coercion', '')
    rbs.gsub!('alias <=> compare_with_coercion', '')
    rbs.gsub!('alias eql? eql_with_coercion', '')
    rbs.gsub!('alias self.at self.at_with_coercion', '')
    rbs.gsub!('alias inspect readable_inspect', '')
    rbs.gsub!('alias default_inspect inspect', '')

    rbs.gsub!('HashWithIndifferentAccess: untyped', <<~RBS)
      # NOTE: HashWithIndifferentAccess and ActiveSupport::HashWithIndifferentAccess are the same object
      #       but RBS doesn't have class alias syntax
      class HashWithIndifferentAccess[T, U] < ActiveSupport::HashWithIndifferentAccess[T, U]
      end
    RBS
  when 'actionview'
    rbs.gsub!(
      'class CheckBoxBuilder < Builder',
      'class CheckBoxBuilder < CollectionHelpers::Builder')
    rbs.gsub!(
      'class RadioButtonBuilder < Builder',
      'class RadioButtonBuilder < CollectionHelpers::Builder')
    rbs.gsub!('TemplateError: untyped', <<~RBS)
      # It is actual TemplateError = Template::Error, but we can't write it in RBS
      class TemplateError < Template::Error
      end
    RBS
  when 'activerecord'
    rbs.gsub!(':==', 'Symbol') # To avoid syntax error

    rbs.gsub!(
      '< Type::Value',
      '< ActiveModel::Type::Value')
    rbs.gsub!(
      '< Type::Binary',
      '< ActiveModel::Type::Binary')
    rbs.gsub!(
      '< Type::Decimal',
      '< ActiveModel::Type::Decimal')
    rbs.gsub!(
      '< Type::String',
      '< ActiveModel::Type::String')
    rbs.gsub!(
      '< Type::Integer',
      '< ActiveModel::Type::Integer')

    rbs.gsub!(
      'class SchemaDumper < SchemaDumper',
      'class SchemaDumper < ActiveRecord::SchemaDumper')
    rbs.gsub!(
      'def schema_creation: () -> SchemaCreation',
      'def schema_creation: () -> untyped')
    rbs.gsub!('V6_0: untyped', <<~RBS)
      # V6_0 and Current are the same object actually. hack for https://github.com/ruby/rbs/issues/345
      class V6_0 < Current
      end
    RBS
    rbs.gsub!('alias numeric decimal', '')

    # XXX: I guess add-type-params.rb resolves this
    rbs.gsub!(
      '-> ColumnDefinition',
      '-> ColumnDefinition[untyped]')
    # XXX: I guess add-type-params.rb resolves this
    rbs.gsub!(
      'def build_point: (untyped x, untyped y) -> ActiveRecord::Point',
      'def build_point: (untyped x, untyped y) -> ActiveRecord::Point[untyped]')
    # XXX: I guess add-type-params.rb resolves this
    rbs.gsub!(
      'class NullMigration < MigrationProxy',
      'class NullMigration[T] < MigrationProxy[T]')
    # XXX: I guess add-type-params.rb resolves this
    rbs.gsub!(
      '-> JoinKeys',
      '-> JoinKeys[untyped]')
    # XXX: I guess add-type-params.rb resolves this
    rbs.gsub!(
      'def row_num_literal: (untyped order_by) -> RowNumber',
      'def row_num_literal: (untyped order_by) -> RowNumber[untyped]')

    rbs.gsub!(
      'def get_database_version: () -> Version',
      'def get_database_version: () -> AbstractAdapter::Version')
    rbs.gsub!(
      'def get_database_version: () -> SQLite3Adapter::Version',
      'def get_database_version: () -> AbstractAdapter::Version')
    rbs.gsub!(
      'def []: (untyped name) -> Attribute',
      'def []: (untyped name) -> ::Arel::Attributes::Attribute')
  end
end

def generated_rbs_path(name)
  version = __dir__[%r!/([^/]+)/_scripts$!, 1]
  Pathname(__dir__) / '../../../' / name / version / "#{name}-generated.rbs"
end

def generate1!(name)
  files = Pathname(RAILS_CODE_DIR).join(name, 'lib').glob('**/*.rb').sort.map(&:to_s)
  generated_rbs_path = generated_rbs_path(name)

  rbs = sh! 'ruby', bin("rbs-prototype-rb.rb"), 'prototype', 'rb', *files
  rbs.gsub!(/^(?<indent>\s*)class (?<name>\S+) < $/) { "#{$~[:indent]}class #{$~[:name]} # Note: It inherits unnamed class, but omitted" }
  rbs.gsub!(/[^[:ascii:]]+/, '(trim non-ascii characters)')
  patch! name, rbs
  generated_rbs_path.write(rbs)

end

def generate2!(name)
  generated_rbs_path = generated_rbs_path(name)

  rbs = sh! 'ruby', bin('add-type-params.rb'), generated_rbs_path.to_s
  generated_rbs_path.write(rbs)

  sh!({ 'ONLY' => name }, 'ruby', bin('postprocess.rb'), '-rlogger', '-rmutex_m', '-Iassets/sig', '-Isig', 'assets/')
end

def main(name)
  if name == 'all'
    gems = %w[activesupport actionpack activejob activemodel actionview activerecord railties]
    gems.each { |n| generate1!(n) }
    gems.each { |n| generate2!(n) }
  else
    generate1!(name)
    generate2!(name)
  end
end

main(*ARGV)
