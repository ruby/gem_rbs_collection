require "pagy"
require "pagy/extras/overflow"
require "pagy/extras/countless"
require "pagy/extras/array"
require "pagy/extras/arel"
require "pagy/extras/size"
require "pagy/extras/bootstrap"

Pagy::DEFAULT[:limit] = 25
Pagy::DEFAULT[:overflow] = :last_page
Pagy::DEFAULT[:size] = [1, 3, 3, 1]
Pagy::DEFAULT[:nav_class] = "pagy-bootstrap-nav"

version = Pagy::VERSION
version.upcase

class Product < ActiveRecord::Base
end

class ProductsController
  include Pagy::Backend

  def params
    { page: "2" }
  end

  def index
    # @type var pagy: Pagy
    pagy, _records = pagy(Product.all, limit: 10, page: 2, overflow: :empty_page)

    count = pagy.count + pagy.from + pagy.to + pagy.in
    offset = pagy.offset + pagy.limit + pagy.page + pagy.last + pagy.pages
    neighbours = [pagy.prev, pagy.next].compact.sum
    series = pagy.series
    sized = pagy.series(size: [1, 3, 3, 1])
    vars = pagy.vars
    vars.fetch(:limit)
    [count, offset, neighbours, series.size, sized.size, pagy.overflow?]
  end

  def countless
    # @type var pagy: Pagy::Countless
    pagy, _records = pagy_countless(Product.all, limit: 5, page: 1)
    # @type var count: nil
    count = pagy.count
    [count, pagy.next]
  end

  def array
    # @type var pagy: Pagy
    # @type var items: Array[String]
    pagy, items = pagy_array(["a", "b", "c"], limit: 2, page: 1)
    [pagy.page, items.map(&:upcase)]
  end

  def arel
    # @type var pagy: Pagy
    pagy, _records = pagy_arel(Product.all, limit: 1, page: "1", overflow: :last_page)
    pagy.pages
  end

  def overflow
    pagy, _records = pagy(Product.all, page: 5, limit: 1)
    pagy.last
  rescue Pagy::OverflowError => e
    e.pagy.last
  rescue Pagy::VariableError => e
    [e.variable.to_s, e.value, e.message]
  end
end

class PresenterHelper
  include Pagy::Frontend

  def render(pagy)
    # @type var pagy: Pagy
    nav = pagy_nav(pagy)
    nav_with_id = pagy_nav(pagy, id: "nav", aria_label: "Pages")
    info = pagy_info(pagy, item_name: "items")
    bootstrap = pagy_bootstrap_nav(pagy, classes: "pagination")
    nav.length + nav_with_id.length + info.length + bootstrap.length
  end
end

pagy = Pagy.new(count: 100, page: 3, limit: 10)
pagy.count.succ
pagy.next&.succ
pagy.prev&.succ

opts = { count: 50, limit: 10 }
Pagy.new(**opts, page: 2).pages.succ
