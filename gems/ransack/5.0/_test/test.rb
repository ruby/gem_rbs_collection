require "active_record"
require "action_view"
require "ransack"
require "ransack/helpers"

Ransack.configure do |config|
  config.search_key = :query
  config.ignore_unknown_conditions = false
  config.default_predicate = "eq"
  config.custom_arrows = { up_arrow: "^", down_arrow: "v", default_arrow: "-" }
  config.sanitize_custom_scope_booleans = false
  config.fields_sort_option = :nulls_first
  config.postgres_fields_sort_option = :nulls_always_last
  config.hide_sort_order_indicators = true
  config.strip_whitespace = false
  config.ignore_blank_values = false

  # @type var predicate_options: Hash[Symbol, untyped]
  predicate_options = { arel_predicate: "matches", formatter: proc { |v| "#{v}%" } }
  config.add_predicate "has_prefix", predicate_options

  config.add_predicate "has_substring",
                       arel_predicate: "matches",
                       formatter: proc { |v| "%#{v}%" },
                       validator: ->(v) { true },
                       type: :string,
                       compounds: false,
                       case_insensitive: true
end

Ransack::VERSION.upcase

class Article < ActiveRecord::Base
  def self.ransackable_attributes(auth_object = nil)
    %w[title body published_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[comments]
  end

  def self.ransackable_scopes(auth_object = nil)
    [:published]
  end

  ransacker :title_length, type: :integer do |parent|
    Arel.sql("LENGTH(#{parent.table_name}.title)")
  end

  ransacker :title_lower, formatter: proc { |value| "#{value}".downcase }, args: [:parent] do |parent|
    Arel.sql("LOWER(#{parent.table_name}.title)")
  end

  ransacker :body_length, callable: ->(parent) { Arel.sql("LENGTH(#{parent.table_name}.body)") }

  # @type var ransacker_options: Hash[Symbol, untyped]
  ransacker_options = { type: :string }
  ransacker :title_upper, ransacker_options do |parent|
    Arel.sql("UPPER(#{parent.table_name}.title)")
  end

  ransack_alias :text, :title_or_body
end

class Comment < ActiveRecord::Base
  def self.ransackable_attributes(auth_object = nil)
    :admin == auth_object ? %w[body created_at author_email] : %w[body created_at]
  end
end

ransackers = Article._ransackers #: Hash[String, Ransack::Ransacker]
ransackers.keys.first&.upcase
aliases = Article._ransack_aliases #: Hash[String, String]
aliases["text"]&.upcase

Article.ransackable_attributes.first&.upcase
Article.ransackable_attributes(:admin)
Article.ransortable_attributes.first&.upcase
Article.ransackable_associations.first&.upcase
Article.ransackable_scopes.first
Article.ransackable_scopes_skip_sanitize_args.first
Article.authorizable_ransackable_attributes.first&.upcase
Article.authorizable_ransackable_associations.first&.upcase

search = Article.ransack(title_cont: "ruby") #: Ransack::Search
search = Article.ransack({ "title_cont" => "ruby" }, search_key: :article_search, ignore_unknown_conditions: false)
search = Article.ransack({ title_cont: " ruby " }, auth_object: :admin, strip_whitespace: true)
search = Article.ransack(nil)
# @type var dynamic_options: Hash[Symbol, untyped]
dynamic_options = { auth_object: :admin, search_key: :q }
search = Article.ransack({ title_cont: "ruby" }, dynamic_options)
strict = Article.ransack!({ title_cont: "ruby" }) #: Ransack::Search
strict.klass.name
direct = Ransack::Search.new(Article) #: Ransack::Search
direct = Ransack::Search.new(Article.where(id: 1), { s: "title desc" }, { auth_object: nil })
direct.object.count

relation = Article.where(id: 1).ransack(title_cont: "ruby").result #: ActiveRecord::Relation
relation.to_a
Article.where(id: 1).ransack!(title_cont: "ruby").result(distinct: true).count
search.result.first
search.result(distinct: true).count

search.sorts = "title desc"
search.sorts = ["title desc", "body asc"]
search.sorts = [{ name: "title", dir: "desc" }]
search.s = "title asc"
sorts = search.sorts #: Array[Ransack::Nodes::Sort]
sorts.first&.name&.upcase
sorts.first&.dir&.upcase
sorts.first&.valid?
sorts.first&.ransacker_args
search.s.size

sort = search.build_sort(name: "title", dir: "desc") #: Ransack::Nodes::Sort
sort.name = :body
sort.dir = "asc"
sort.valid?
# @type var dynamic_sort: Hash[Symbol, untyped]
dynamic_sort = { name: "title", dir: "asc" }
search.build_sort(dynamic_sort)
loose_sort = search.new_sort(name: "body") #: Ransack::Nodes::Sort
loose_sort.dir&.upcase

grouping = search.build_grouping(m: "or") #: Ransack::Nodes::Grouping
grouping.combinator
grouping.m
grouping.combinator = "and"
grouping.m = :or
grouping.c.size
grouping.g.size
grouping.conditions.size
grouping.groupings.size
grouping.values.size
grouping["title_cont"]
new_grouping = search.new_grouping(m: "or") #: Ransack::Nodes::Grouping
new_grouping.build_grouping.new_grouping
grouping.new_condition(attributes: 1, values: 2)
grouping.new_condition({ attributes: 1 })

condition = search.build_condition #: Ransack::Nodes::Condition
condition = search.build_condition(attributes: 2, values: 1)
# @type var dynamic_condition: Hash[Symbol, untyped]
dynamic_condition = { attributes: 1, values: 1 }
condition = search.build_condition(dynamic_condition)
other_condition = search.new_condition(attributes: 1) #: Ransack::Nodes::Condition
other_condition.values.size
condition.predicate_name = "cont"
condition.predicate_name&.upcase
predicate = condition.predicate
predicate&.name&.upcase
predicate&.arel_predicate
predicate&.type
predicate&.formatter
predicate&.validator
predicate&.compound
predicate&.wants_array
predicate&.case_insensitive
condition.combinator = "or"
condition.m = :and
condition.combinator&.upcase
condition.m&.upcase
attribute = condition.build_attribute("title", []) #: Ransack::Nodes::Attribute
attribute.name = "body"
attribute.name&.upcase
attribute.ransacker_args.size
value = condition.build_value("ruby") #: Ransack::Nodes::Value
value.value = "rails"
condition.attributes.first&.name
condition.a.size
condition.values.first&.value
condition.v.size
parsed = Article.ransack(title_cont: "ruby").conditions.first #: Ransack::Nodes::Condition?
parsed&.value
parsed&.predicate&.name
grouping.build_condition.build_attribute

search.conditions.size
search.groupings.size
search.combinator
search.base.conditions.size
search.context.search_key
search.context.search_key = :query
search.context.auth_object = :admin
search.context.ignore_unknown_conditions = false
search.context.auth_object
search.context.klass.name
search.context.object.count
search.context.ignore_unknown_conditions
search.translate(:title)&.upcase

class ArticlesView < ActionView::Base
  include Ransack::Helpers::FormHelper

  def render_search(search)
    search_form_for(search, url: "/articles", html: { class: "search" }) do |f|
      f.label(:title_cont)
      f.search_field(:title_cont)
      f.submit
    end
    search_form_for([:admin, search], as: :query) { |f| f.submit }
    search_form_with(search, url: "/articles") { |f| f.submit }
    search_form_with(model: search) { |f| f.submit }
    turbo_search_form_for(search, url: "/articles", turbo_action: "replace") do |f|
      f.attribute_select
      f.predicate_select
      f.sort_select
    end
    search_form_for(search) do |f|
      f.attribute_select({ associations: ["comments"], include_blank: false }, { class: "wide" })
      f.predicate_select({ compounds: false, only: ["eq", "cont"] }, { class: "narrow" })
      f.combinator_select
      f.sort_direction_select
      f.sort_select({ default: "title" })
      f.condition_fields do |c|
        c.attribute_select
        c.predicate_select
        c.value_fields { |v| v.text_field(:value) }
      end
      f.condition_fields(search.base.conditions) { |c| c.attribute_fields { |a| a.text_field(:name) } }
      f.grouping_fields(search.base.groupings, object_name: "q") { |g| g.combinator_select }
      f.sort_fields { |s| s.sort_select }
      f.sort_fields(search.sorts, child_index: 0) { |s| s.sort_direction_select }
      f.predicate_fields { |p| p.text_field(:name) }
      f.sort_link(:title)
      f.sort_link(:title, "Title")
      f.sort_link(:title, ["title desc"], "Title", class: "x")
      f.sort_url(:title, default_order: :desc)
    end
  end

  def render_table(search)
    links = [] #: Array[ActiveSupport::SafeBuffer]
    links << sort_link(search, :title)
    links << sort_link(search, :title, "Title")
    links << sort_link(search, :title, { aria: { label: "Sort by title" } })
    links << sort_link(search, :created_at, [:created_at, "id desc"], "Date", default_order: :desc)
    links << sort_link([:admin, search], :title, hide_indicator: true)
    links << sort_link(search, :title) { "Title" }
    url = sort_url(search, :title, default_order: :desc) #: String
    url.upcase
    sort_url([:admin, search], :title)
    links
  end
end
