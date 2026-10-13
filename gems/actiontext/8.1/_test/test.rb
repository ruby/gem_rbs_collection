require "actiontext"

class Article < ActiveRecord::Base
  has_rich_text :content
end

class Comment < ActiveRecord::Base
  has_rich_text :body, store_if_blank: false
end

ActionView::Helpers::FormBuilder.new(:article, Article.new, ActionView::Base.empty, {}).rich_textarea(:content, class: "editor")
ActionText::Content.render(partial: "action_text/contents/content")
ActionText::Attachment.fragment_by_minifying_attachments("<p>text</p>")

rich_text = ActionText::RichText.new
rich_text.name.to_sym
rich_text.body&.to_html
rich_text.embeds.attached?
rich_text.updated_at.to_date
rich_text.to_s.size
rich_text.to_plain_text.size
rich_text.to_trix_html&.size
if (content = rich_text.body)
  content.links.first&.size
  content.attachments.first&.to_html
  content.gallery_attachments.size
  content.to_plain_text.size
  content.to_trix_html.size
  content.to_html.size
  content.to_s.size
end
