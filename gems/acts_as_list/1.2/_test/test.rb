require "acts_as_list"

class TodoList < ActiveRecord::Base
  has_many :todo_items
end

class TodoItem < ActiveRecord::Base
  belongs_to :todo_list

  acts_as_list scope: :todo_list
end

class Chapter < ActiveRecord::Base
  acts_as_list
end

class Attachment < ActiveRecord::Base
  acts_as_list(
    column: :sort_order,
    scope: [:owner_id, :kind],
    top_of_list: 0,
    add_new_at: :top,
    sequential_updates: false,
    touch_on_update: false
  )
end

class Entry < ActiveRecord::Base
  acts_as_list scope: [:category_id, :region, { archived_at: nil }], column: "rank", add_new_at: nil
end

class Page < ActiveRecord::Base
  list_options = { column: :page_number, add_new_at: :bottom }
  acts_as_list(list_options)
end

item = TodoItem.new
item.insert_at
item.insert_at(2)
item.insert_at!(3)
item.move_lower
item.move_higher
item.move_to_bottom
item.move_to_top
item.remove_from_list

item.increment_position
item.decrement_position
item.set_list_position(3)
item.set_list_position(nil, true)

# @type var position: Integer?
position = item.current_position
# @type var default: Integer?
default = item.default_position

flags = [item.first?, item.last?, item.in_list?, item.not_in_list?, item.default_position?]
flags.each { |flag| flag ? 1 : 0 }

# @type var higher: TodoItem?
higher = item.higher_item
# @type var lower: TodoItem?
lower = item.lower_item
higher&.move_to_bottom
lower&.move_to_top

# @type var above: ActiveRecord::Relation
above = item.higher_items
# @type var below: ActiveRecord::Relation
below = item.lower_items(3)
item.higher_items(nil).count
item.lower_items.count

TodoItem.acts_as_list_no_update do
  item.update(position: 2)
end

# @type var result: String
result = TodoItem.acts_as_list_no_update([Attachment, Chapter]) { "done" }
ActiveRecord::Acts::List::VERSION.size
