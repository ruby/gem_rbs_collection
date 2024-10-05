# curl https://raw.githubusercontent.com/stripe/openapi/refs/heads/master/openapi/spec3.yaml | ruby openapi.rb customer

require 'yaml'

spec3 = YAML.safe_load($stdin.read)

class Spec
  def initialize(spec, indent:, argv:)
    @spec = spec
    @indent = indent
    @argv = argv
  end

  def schema(name)
    @spec['components']['schemas'][name]
  end

  def rbs
    @argv.each_with_index do |name, index|
      s = schema(name)
      puts "#{i}#{desc(s['description'])}"
      puts "#{i}interface #{interface_name(s)}"
      nest do
        puts build_rbs_from_properties(s['properties'])
      end
      puts "#{i}end"
      puts if index != @argv.size - 1
    end
  end

  private

  def nest
    @indent += 2
    yield
  ensure
    @indent -= 2
  end

  def i(adjust = 0)
    ' ' * (@indent + adjust)
  end

  def build_rbs_from_properties(properties)
    properties.map do |name, property|
      "#{i(-2)}#{desc(property['description'])}\n" \
      "#{i}#{build_rbs_from_property(name, property, :getter)}\n\n" \
      "#{i(-2)}#{desc(property['description'])}\n" \
      "#{i}#{build_rbs_from_property(name, property, :setter)}"
    end.join("\n\n")
  end

  def desc(description)
    return '' unless description

    description.split("\n").map { |line| "#{i(-2)}# #{line}" }.join("\n  ")
  end

  def build_rbs_from_property(name, property, kind)
    return build_rbs_from_property(name, ref(property['$ref']), kind) if property['$ref']

    type = build_type(name, property)
    type = "#{type}?" if property['nullable']
    definition(kind, name, type)
  end

  def build_type(name, property)
    if property['anyOf']
      types = property['anyOf'].map { |p| class_name(name, p) }.uniq
      types.delete('untyped') if types.length > 1
      return types.join(' | ') unless types.length > 1

      types.delete('untyped')
      return "(#{types.join(' | ')})"

    end

    case property['type']
    when nil
      'untyped'
    when 'object'
      case name
      when *@argv
        class_name(name, property)
      else
        'untyped'
      end
    when 'string'
      if property['enum']
        types = property['enum'].map { |e| "\"#{e}\"" }
        if types.length > 1
          "(#{types.join(' | ')})"
        else
          types.join(' | ')
        end
      else
        'String'
      end
    when 'array'
      "Array[#{type2rbs(property['items']['type'])}]"
    when 'integer'
      'Integer'
    when 'boolean'
      'bool'
    else
      'untyped'
    end
  end

  def class_name(name, property)
    return class_name(name, ref(property['$ref'])) if property['$ref']

    case property['type']
    when 'object'
      if @argv.include?(name)
        interface_name(property)
      else
        'untyped'
      end
    else
      type2rbs(property['type'])
    end
  end

  def resource_name(property)
    property['title']
  end

  def interface_name(property)
    "_#{property['title']}"
  end

  def definition(kind, name, type)
    case kind
    in :getter
      "def #{name}: () -> #{type}"
    in :setter
      "def #{name}=: (#{type}) -> #{type}"
    end
  end

  def ref(ref_key)
    _, *paths = ref_key.split('/')
    @spec.dig(*paths)
  end

  def type2rbs(type)
    case type
    when 'string'
      'String'
    when 'integer'
      'Integer'
    when 'boolean'
      'bool'
    else
      'untyped'
    end
  end
end

puts 'module Stripe'
Spec.new(spec3, indent: 2, argv: ARGV.dup).rbs
puts 'end'
