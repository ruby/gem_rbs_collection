# !!! GENERATED FILE !!!
# Please see generators/yard-generator/README.md

require 'yard'

YARD::Registry.root.children.each do |child|
  child.name(false)
  child.docstring.all
end

::YARD::DocstringParser.new.parse("@option a b [String]").tags.each do |tag|
  case tag
  when YARD::Tags::OverloadTag
    tag.types
  when YARD::Tags::OptionTag
    tag.pair.defaults
  when YARD::Tags::Tag
    tag.name
  end
end

types_explainers = ::YARD::Tags::TypesExplainer::Parser.parse("Hash{Symbol => String}")
types_explainers.each do |types_explainer|
  case types_explainer
  when YARD::Tags::TypesExplainer::HashCollectionType
    types_explainer.key_types.each { }
  when YARD::Tags::TypesExplainer::FixedCollectionType
    types_explainer.types.each { }
  when YARD::Tags::TypesExplainer::CollectionType
    types_explainer.types.each { }
  else
    types_explainer.name
  end
end
