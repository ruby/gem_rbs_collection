require "kaminari-core"

Kaminari.configure do |config|
  config.default_per_page = 20
  config.max_per_page = 100
  config.window = 2
  config.outer_window = 0
  config.left = 0
  config.right = 0
  config.page_method_name = :page
  config.param_name = :p
  config.max_pages = 10
  config.params_on_first_page = false
end
Kaminari.config.param_name

Kaminari.configure do |config|
  config.param_name = _ = -> () { :page }
  config.max_per_page = nil
  config.max_pages = nil
end
Kaminari.config.param_name

# @type var default_per_page: Integer
default_per_page = Kaminari.config.default_per_page
# @type var max_per_page: Integer?
max_per_page = Kaminari.config.max_per_page
# @type var window: Integer
window = Kaminari.config.window
Kaminari.config.outer_window
Kaminari.config.left
Kaminari.config.right
# @type var page_method_name: Symbol | String
page_method_name = Kaminari.config.page_method_name
# @type var param_name: Symbol | String
param_name = Kaminari.config.param_name
# @type var max_pages: Integer?
max_pages = Kaminari.config.max_pages
# @type var params_on_first_page: bool
params_on_first_page = Kaminari.config.params_on_first_page
# @type var deprecator: ActiveSupport::Deprecation
deprecator = Kaminari.deprecator
# @type var version: String
version = Kaminari::Core::VERSION

class ModelRelation
  include Kaminari::PageScopeMethods

  def limit(_num)
    self
  end

  def offset(_num)
    self
  end
end
model = ModelRelation.new
model.per(10)
model.per(20).total_pages
# @type var per: ModelRelation
per = model.per("10", max_per_page: 50)
model.per(nil)
model.max_paginates_per(30)
model.padding(2)
model.padding("2")
# @type var total_pages: Integer
total_pages = model.total_pages
# @type var current_page: Integer
current_page = model.current_page
# @type var next_page: Integer?
next_page = model.next_page
# @type var prev_page: Integer?
prev_page = model.prev_page
# @type var first_page: bool
first_page = model.first_page?
model.last_page?
model.out_of_range?
# @type var paginated: bool
paginated = model.paginated?

begin
  model.total_pages
rescue Kaminari::ZeroPerPageOperation => e
  e.message
end

class Article
  extend Kaminari::ConfigurationMethods::ClassMethods
end
# @type var per_value: Integer?
per_value = Article.paginates_per(10)
# @type var article_default: Integer
article_default = Article.default_per_page
Article.max_paginates_per(50)
# @type var article_max_per_page: Integer?
article_max_per_page = Article.max_per_page
Article.max_pages(5)
# @type var article_max_pages: Integer?
article_max_pages = Article.max_pages

# @type var array: Kaminari::PaginatableArray[Integer]
array = Kaminari.paginate_array([1, 2, 3], total_count: 3)
# @type var paged: Kaminari::PaginatableArray[Integer]
paged = array.page(2).per(1)
# @type var element: Integer?
element = paged.first
# @type var array_total_pages: Integer
array_total_pages = array.page("1").total_pages
# @type var total_count: Integer
total_count = array.total_count
# @type var entry_name: String
entry_name = array.entry_name(count: 2)
array.limit(2).offset(1)
array.limit_value
array.offset_value
array.paginated?
Kaminari::PaginatableArray.new(%w[a b c], limit: 2, offset: 0)

class View
  include Kaminari::Helpers::HelperMethods
end
view = View.new
# @type var next_url: String?
next_url = view.next_page_url(model, params: { controller: "users" })
view.next_page_path(model, { param_name: :p })
view.prev_page_url(model)
view.prev_page_path(model)
# @type var paginate: String
paginate = view.paginate(model, window: 2)
# @type var link: String?
link = view.link_to_previous_page(model, "Previous", remote: true)
# @type var link_or_block: String | Symbol
link_or_block = view.link_to_next_page(model, "Next") { :none }
# @type var info: String
info = view.page_entries_info(model, entry_name: "item")
# @type var tags: String
tags = view.rel_next_prev_link_tags(model, param_name: :p)

# @type var paged_max: Kaminari::PaginatableArray[Integer] & Kaminari::PaginatableArray::_PageScopeMethods[Integer]
paged_max = array.page(1).max_paginates_per(2).padding(1)
paged_max.current_page

# @type var sliced: Kaminari::PaginatableArray[String] & Kaminari::PaginatableArray::_PageScopeMethods[String]
sliced = Kaminari.paginate_array(%w[a b c], limit: 2, offset: 0)
sliced.total_pages
