require 'active_support/all'

# Test ActiveSupport::NumericWithFormat
42.to_s
42.to_s(:phone)

5.try(:to_s)
5.try('round', 2)
5.try(:tap) { |n| p n }
5.try { p 'hello' }
5.try { |n| p n }
nil.try(:to_s)
nil.try('round', 2)
nil.try(:tap) { |n| p n }
nil.try { p 'hello' }
nil.try { |n| p n }
[1, 2, 3, 4].in_groups(2)
[1, 2, 3, 4].in_groups(2) { |group| p group }

hash = { a: 1, b: 2, c: 3 }
hash.stringify_keys
hash.stringify_keys!

hash.symbolize_keys
hash.symbolize_keys!

hash = { hoge: { hogefuga: { hogehoge: 1 }, fugahoge: 2 }, fuga: 3 }
hash.deep_stringify_keys
hash.deep_stringify_keys!

hash.deep_symbolize_keys
hash.deep_symbolize_keys!

ActiveSupport::SecurityUtils.secure_compare('tokenA', 'tokenB') === false

class TestAttrInternal
  attr_internal_reader :internal_variable_reader_1
  attr_internal_reader 'internal_variable_reader_2', :internal_variable_reader_3
  attr_internal_writer :internal_variable_writer_1
  attr_internal_writer 'internal_variable_writer_2'
  attr_internal_writer :internal_variable_accessor_1
  attr_internal_writer 'internal_variable_accessor_2'
end

"yukihiro_matz".constantize
"yukihiro_matz".safe_constantize
"string_ending_with_id".titleize(keep_id_suffix: true).titleize
"::Net::HTTP".deconstantize.demodulize
"Donald E. Knuth".parameterize(separator: ":", preserve_case: true, locale: :en).parameterize
"ham_and_egg".tableize.classify
"author_id".humanize(capitalize: false, keep_id_suffix: true).humanize
"iD".upcase_first
"User".foreign_key(false).foreign_key
"yukihiro_matz".camelize.underscore.dasherize
"rabbit".pluralize.singularize
"rabbit".pluralize(2).pluralize(:en).pluralize(2, :en)
"rabbits".singularize(:en)

itself if Object.new.blank? \
            ^ nil.blank? \
            ^ false.blank? \
            ^ true.blank? \
            ^ [1].blank? \
            ^ {a: "hi"}.blank? \
            ^ "".blank? \
            ^ 0.blank? \
            ^ Time.now.blank? \
            ^ "a".present?
