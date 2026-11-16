require "will_paginate"
require "will_paginate/active_record"
require "will_paginate/array"
require "will_paginate/collection"
require "will_paginate/view_helpers/action_view"

class Article < ActiveRecord::Base
  self.per_page = 20
end

class Comment < ActiveRecord::Base
end

WillPaginate.per_page = 50
default_per_page = WillPaginate.per_page
default_per_page.succ

Article.per_page.succ
Comment.per_page = "15"

# @type var articles: Article::ActiveRecord_Relation
articles = Article.paginate(page: "2")
articles = Article.paginate(page: 3, per_page: 10)
# @type var paginate_options: Hash[Symbol, untyped]
paginate_options = { page: 4, per_page: 15 }
articles = Article.paginate(paginate_options)
articles = Article.paginate(page: nil, per_page: "10", total_entries: 100)
articles = Article.where(published: true).paginate(page: 1)
articles = articles.paginate(page: 1, per_page: 5)

# @type var paged: ActiveRecord::Relation
paged = Article.page(2)
paged = Article.where(published: true).page(nil)
paged = paged.per_page(5)

articles.total_entries.succ
articles.total_pages.succ
articles.current_page.to_i.succ
articles.per_page&.succ
articles.out_of_bounds?
articles.next_page&.succ
articles.previous_page&.succ

# @type var offset: WillPaginate::PageNumber
offset = articles.current_page.to_offset(10)
offset.to_i.succ
(articles.current_page + 1).succ
(articles.current_page - 1).succ

# @type var items: WillPaginate::Collection[String]
items = %w[a b c d e].paginate(page: 2, per_page: 2)
items = %w[a b c d e].paginate
items = %w[a b c d e].paginate(paginate_options)
items = %w[a b c d e].paginate(page: nil, per_page: "2", total_entries: 5)
items.first&.upcase
items.total_entries&.succ
items.total_pages.succ
items.current_page.to_i.succ
items.per_page.succ
items.offset.succ
items.out_of_bounds?
items.next_page&.succ
items.previous_page&.succ

# @type var pager: WillPaginate::Collection[Integer]
pager = WillPaginate::Collection.create("2", 30, 100) do |collection|
  collection.replace([1, 2, 3].take(collection.per_page))
  collection.total_entries = 100
end
pager.first&.succ

WillPaginate::Collection.create(1, 10, 20) { |page_data| page_data.replace((1..20).to_a) }.total_pages

# @type var plain: WillPaginate::Collection[Symbol]
plain = WillPaginate::Collection.new(1, 10, 3)
plain.replace([:a, :b])
plain = WillPaginate::Collection.new(1)

class CustomRenderer < WillPaginate::ActionView::LinkRenderer
  def to_html
    container_attributes[:role]
    super.upcase
  end
end

class PostsHelper
  include WillPaginate::ViewHelpers

  def render_links(posts)
    # @type var html: String?
    html = will_paginate(posts, previous_label: "Prev", next_label: "Next", inner_window: 1, renderer: CustomRenderer)
    html = will_paginate(posts)
    page_entries_info(posts, html: false).upcase
  end
end

class PaginatedView
  include WillPaginate::ActionView

  def render_links
    will_paginate(items, class: "pager")
    will_paginate(class: "pager")
    page_entries_info(items)
    page_entries_info(model: Article)
    paginated_section(items) { "content" }.upcase
  end

  def items
    %w[a b].paginate(page: 1)
  end
end

WillPaginate::ViewHelpers.pagination_options[:page_links] = false
WillPaginate::ViewHelpers.pagination_options = { page_links: true }

begin
  Article.paginate(page: "x")
rescue WillPaginate::InvalidPage
  nil
end
