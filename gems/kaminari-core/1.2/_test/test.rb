# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

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
  config.param_name = -> () { :page }
  config.max_per_page = nil
  config.max_pages = nil
end
Kaminari.config.param_name

Kaminari.config.default_per_page
Kaminari.config.max_per_page
Kaminari.config.window
Kaminari.config.outer_window
Kaminari.config.left
Kaminari.config.right
Kaminari.config.page_method_name
Kaminari.config.param_name
Kaminari.config.max_pages
Kaminari.config.params_on_first_page

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
model.total_pages
model.current_page
model.next_page
model.prev_page
model.first_page?
model.last_page?
model.out_of_range?
