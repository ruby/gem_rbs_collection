require "pagy"

Pagy::OPTIONS[:limit] = 25
Pagy::OPTIONS[:max_limit] = 100
Pagy::OPTIONS[:raise_range_error] = true
Pagy::OPTIONS.freeze

Pagy.translate_with_the_slower_i18n_gem!

version = Pagy::VERSION
version.upcase
Pagy::DEFAULT.fetch(:limit)
Pagy::ROOT.join("locales")

Pagy::I18n.locale = "pt-BR"
Pagy::I18n.locale.upcase
Pagy::I18n.translate("pagy.gap").upcase
Pagy::I18n.pathnames.any? { |path| path.join("en.yml").exist? }

class Product < ActiveRecord::Base
end

class ProductsController
  include Pagy::Method

  def request
    Object.new
  end

  def index
    # @type var pagy: Pagy::Offset
    pagy, _records = pagy(:offset, Product.all, limit: 10, page: 2)

    count = pagy.count + pagy.from + pagy.to + pagy.in
    position = pagy.offset + pagy.limit + pagy.page + pagy.last + pagy.pages
    neighbours = [pagy.previous, pagy.next].compact.sum
    html = [pagy.series_nav, pagy.series_nav(:bootstrap, classes: "pagination"), pagy.series_nav_js,
            pagy.input_nav_js, pagy.info_tag(item_name: "products"), pagy.limit_tag_js(id: "limit")]
    urls = [pagy.page_url(:next), pagy.page_url(:previous), pagy.page_url(3, absolute: true)].compact
    options = pagy.options.fetch(:limit)
    [count, position, neighbours, html.size, urls.size, options]
  end

  def countless
    # @type var pagy: Pagy::Offset::Countless
    pagy, _records = pagy(:countless, Product.all, limit: 5)
    pagy.next
  end

  def countish
    # @type var pagy: Pagy::Offset::Countish
    pagy, _records = pagy(:countish, Product.all, limit: 5, page: 1, ttl: 300, max_pages: 100)
    pagy.pages
  end

  def other_paginator
    # @type var pagy: Pagy
    pagy, _records = pagy(:keyset, Product.all, limit: 5)
    pagy.page
  end

  def calendar_paginator
    # @type var calendar: Hash[Symbol, untyped]?
    # @type var offset: Pagy::Offset
    calendar, offset, _records = pagy(:calendar, Product.all, year: { period: nil }, month: { period: nil }, offset: { limit: 5 }, request: { params: { "page" => "1" } })
    calendar&.size
    offset.page
  end

  def default_paginator
    # @type var pagy: Pagy::Offset
    pagy, _records = pagy(Product.all, limit: 20, request: { params: { "page" => "2" } })
    [pagy.previous, pagy.next]
  end

  def range_error
    pagy, _records = pagy(:offset, Product.all, page: 99)
    pagy.last
  rescue Pagy::RangeError => e
    e.pagy.page
  end

  def option_error
    pagy, _records = pagy(:offset, Product.all, page: 0)
    [pagy.page]
  rescue Pagy::OptionError => e
    [e.option.to_s, e.value, e.message]
  end
end

class ProductsRenderer
  include Pagy::Method

  def pagination
    # @type var pagination: Pagy::Offset
    pagination, _records = pagy(:offset, Product.all, page: 1, limit: 50, request: { params: { "page" => "1" } })
    pagination
  end
end

ProductsRenderer.new.pagination.last.succ

offset = Pagy::Offset.new(count: 100, page: 3, limit: 10)
offset.count.succ
offset.previous&.succ
offset.next&.succ

Pagy::Offset::Countless.new(page: 2, limit: 5).count&.succ
class Pagy
  def page_series(**options) = series(**options)
  def page_anchor(**options) = a_lambda(**options)
end

Pagy::Offset.new(count: 100, page: 3).page_series(slots: 5).size
Pagy::Offset.new(count: 100, page: 3).page_anchor(anchor_string: 'data-x="1"').call(2, "two", classes: "link").upcase

opts = { count: 50, limit: 10 }
Pagy::Offset.new(**opts, page: 2).pages.succ

module PagyRequestQueryParamsOnly
end

Pagy::Request.prepend PagyRequestQueryParamsOnly
