require "actiontext"

class Article < ActiveRecord::Base
  has_rich_text :content
end
