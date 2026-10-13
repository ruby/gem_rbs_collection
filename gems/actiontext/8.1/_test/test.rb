require "actiontext"

class Article < ActiveRecord::Base
  has_rich_text :content
end

class Comment < ActiveRecord::Base
  has_rich_text :body, store_if_blank: false
end

ActionView::Helpers::FormBuilder.new(:article, Article.new, ActionView::Base.empty, {}).rich_textarea(:content, class: "editor")
