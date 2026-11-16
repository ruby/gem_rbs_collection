require "acts-as-taggable-on"

class WordParser < ActsAsTaggableOn::DefaultParser
end

class TagCloudHelper
  include ActsAsTaggableOn::TagsHelper
end

ActsAsTaggableOn.setup do |config|
  config.force_lowercase = true
  config.force_parameterize = false
  config.remove_unused_tags = true
  config.tags_counter = false
  config.strict_case_match = true
  config.default_parser = ActsAsTaggableOn::DefaultParser
  config.tags_table = :tags
  config.taggings_table = :taggings
  config.base_class = "::ActiveRecord::Base"
  config.force_binary_collation = false
end

ActsAsTaggableOn.force_lowercase = true
ActsAsTaggableOn.force_parameterize = true
ActsAsTaggableOn.remove_unused_tags = true
ActsAsTaggableOn.tags_counter = false
ActsAsTaggableOn.strict_case_match = false
ActsAsTaggableOn.default_parser = WordParser
ActsAsTaggableOn.tags_table = "tags"
ActsAsTaggableOn.taggings_table = "taggings"
ActsAsTaggableOn.base_class = "::ActiveRecord::Base"
ActsAsTaggableOn.force_binary_collation = false

flags = [
  ActsAsTaggableOn.force_lowercase,
  ActsAsTaggableOn.force_parameterize,
  ActsAsTaggableOn.remove_unused_tags,
  ActsAsTaggableOn.tags_counter,
  ActsAsTaggableOn.strict_case_match
]
flags.first&.itself
ActsAsTaggableOn.default_parser.new("a, b").parse.first&.upcase
ActsAsTaggableOn.tags_table.to_s
ActsAsTaggableOn.taggings_table.to_s
ActsAsTaggableOn.base_class.upcase
delimiter = ActsAsTaggableOn.delimiter #: String | Array[String]
delimiter.size
ActsAsTaggableOn.glue.upcase
ActsAsTaggableOn::VERSION.upcase

class Post < ActiveRecord::Base
  acts_as_taggable_on :tags, :skills
  acts_as_ordered_taggable_on :interests
  acts_as_taggable_tenant :account_id
end

class Photo < ActiveRecord::Base
  acts_as_taggable
  acts_as_ordered_taggable
  acts_as_taggable_on [:locations, "places"]
end

class Member < ActiveRecord::Base
  acts_as_tagger
end

class Member2 < ActiveRecord::Base
  acts_as_tagger dependent: :nullify
end

Post.taggable?

post = Post.new
tags = post.tag_list #: ActsAsTaggableOn::TagList
tags.add("awesome", "slick")
tags.add("awesome, slick", parse: true)
tags.add(["a", "b"], parser: WordParser)
tags.remove("awesome", "slick")
tags.remove("awesome, slick", parse: true)
tags << "cool"
tags.concat(["x", "y"])
summed = tags + ["z"] #: ActsAsTaggableOn::TagList
summed.to_s.upcase
tags.parser = WordParser
tags.parser.new("a").parse.first&.upcase
tags.owner = post
tags.owner
tags.map(&:upcase)
tags.join(", ")

post.tag_list = "awesome, slick"
post.tag_list = ["awesome", "slick"]
post.skill_list.add("ruby").first&.upcase
all_list = post.all_tags_list #: ActsAsTaggableOn::TagList
all_list.first&.upcase
tag_collection = post.tags #: ActsAsTaggableOn::Tag::ActiveRecord_Associations_CollectionProxy
tag_collection.map(&:name).first&.upcase
tag_collection.first&.taggings_count&.succ
tagging_collection = post.tag_taggings #: ActsAsTaggableOn::Tagging::ActiveRecord_Associations_CollectionProxy
tagging_collection.first&.context&.upcase
post.taggings.first&.tag_id&.succ
post.base_tags.first&.name&.upcase

post.tag_list_on(:skills).first&.upcase
post.tag_list_on("skills").first&.upcase
post.set_tag_list_on(:skills, "ruby, rails").first&.upcase
post.all_tags_list_on(:skills).first&.upcase
post.all_tags_on(:skills).first&.name&.upcase
post.tags_on(:skills).first&.name&.upcase
post.tags_on(:skills).where(name: "ruby").count
post.tag_counts_on(:skills, order: "count desc", limit: 3).first&.count&.succ
post.tag_counts.first&.name&.upcase
post.top_tags(5).first&.name&.upcase

member = Member.new
post.owner_tags(member).first&.name&.upcase
post.owner_tags(nil).first&.name&.upcase
post.owner_tags_on(member, :skills).first&.name&.upcase
post.owner_tag_list_on(member, :skills).first&.upcase
post.set_owner_tag_list_on(member, :skills, "ruby, rails").first&.upcase
post.tags_from(member).first&.upcase

saved = member.tag(post, with: "paris, normandy", on: :locations) #: bool?
saved || member.tag(post, with: ["paris"], on: "locations", force: false, skip_save: true)
member.owned_taggings.first&.tagger_id
member.owned_tags.first&.name&.upcase

post.find_related_tags.first
post.find_related_on_tags(ignore: "ruby").first
post.find_related_tags_for(Photo, ignore: ["ruby", "rails"]).first

tagged = Post.tagged_with("awesome") #: Post::ActiveRecord_Relation
tagged.first&.title&.upcase
Post.tagged_with(["awesome", "cool"], match_all: true).first&.title&.upcase
Post.tagged_with(["awesome", "cool"], exclude: true).first&.title&.upcase
Post.tagged_with(["awesome", "cool"], any: true, on: :skills).first&.title&.upcase
Post.tagged_with("awe", wild: :suffix, on: "skills").first&.title&.upcase
Post.tagged_with("awe", wild: true).first&.title&.upcase
# @type var raw_options: Hash[Symbol, untyped]
raw_options = { any: true, on: :skills }
Post.tagged_with(["awesome"], raw_options).first&.title&.upcase
Post.tagged_with("awesome", owned_by: member, on: :tags).first&.title&.upcase
Post.tagged_with("awesome", start_at: Time.now, end_at: Time.now, order_by_matching_tag_count: true, any: true).first&.title&.upcase
Post.where(id: 1).tagged_with("awesome", any: true).tagged_with("cool").first&.title&.upcase
Post.tagged_with("awesome").tag_counts.first&.name&.upcase
Post.tagged_with("awesome").tag_counts_on(:skills).first&.count&.succ

Post.tag_counts_on(:tags, at_least: 2, at_most: 10, conditions: ["name = ?", "x"], start_at: Time.now, end_at: Time.now).first&.name&.upcase
Post.tags_on(:tags, limit: 10, order: "name").first&.name&.upcase
Post.all_tags(on: :tags).first&.name&.upcase
Post.all_tag_counts(on: "tags").first&.count&.succ
Post.tag_counts.first&.name&.upcase
Post.top_tags.first&.name&.upcase
Post.tag_types.first&.to_s&.upcase
Post.preserve_tag_order?
Post.tenant_column

Photo.tagged_with("paris", on: :locations, owned_by: member).first&.location_list&.first&.upcase

ActsAsTaggableOn::Taggable::TaggedWithQuery.build(Post, ActsAsTaggableOn::Tag, ActsAsTaggableOn::Tagging, ["a"], {}).to_a

tag = ActsAsTaggableOn::Tag.new(name: "ruby")
tag.name.upcase
tag.name = "rails"
tag.taggings_count.succ
tag.count.succ
tag.to_s.upcase
tag == tag
tag.taggings.first&.context&.upcase
found = ActsAsTaggableOn::Tag.find_or_create_with_like_by_name("ruby") #: ActsAsTaggableOn::Tag
found.name.upcase
created = ActsAsTaggableOn::Tag.find_or_create_all_with_like_by_name(["ruby", "rails"]) #: Array[ActsAsTaggableOn::Tag]
created.first&.name&.upcase
ActsAsTaggableOn::Tag.find_or_create_all_with_like_by_name("ruby", "rails").first&.name&.upcase
ActsAsTaggableOn::Tag.most_used.first&.name&.upcase
ActsAsTaggableOn::Tag.most_used(5).least_used(3).first&.name&.upcase
ActsAsTaggableOn::Tag.named("ruby").first&.name&.upcase
ActsAsTaggableOn::Tag.named_any(["ruby", "rails"]).first&.name&.upcase
ActsAsTaggableOn::Tag.named_like("ru").first&.name&.upcase
ActsAsTaggableOn::Tag.named_like_any(["ru", "ra"]).where(id: 1).first&.name&.upcase
ActsAsTaggableOn::Tag.for_context(:skills).first&.name&.upcase
ActsAsTaggableOn::Tag.for_tenant(1).first&.name&.upcase
ActsAsTaggableOn::Tag.where(taggings_count: 1..).named("ruby").first&.name&.upcase

tagging = ActsAsTaggableOn::Tagging.new
tagging.tag.name.upcase
tagging.tag = tag
tagging.tag_id.succ
tagging.taggable.id
tagging.taggable_id.succ
tagging.taggable_type.upcase
tagging.tagger&.id
tagging.tagger_id&.succ
tagging.tagger_type&.upcase
tagging.context.upcase
tagging.tenant&.upcase
ActsAsTaggableOn::Tagging::DEFAULT_CONTEXT.upcase
ActsAsTaggableOn::Tagging.owned_by(member).first&.context&.upcase
ActsAsTaggableOn::Tagging.not_owned.by_context(:skills).first&.context&.upcase
ActsAsTaggableOn::Tagging.by_context.first&.context&.upcase
ActsAsTaggableOn::Tagging.by_contexts(["tags", :skills]).first&.context&.upcase
ActsAsTaggableOn::Tagging.by_contexts(nil).first&.context&.upcase
ActsAsTaggableOn::Tagging.by_tenant("1").first&.tenant&.upcase
ActsAsTaggableOn::Tagging.where(taggable_type: "Post").by_context("tags").first&.tag&.name&.upcase

begin
  ActsAsTaggableOn::Tag.find_or_create_all_with_like_by_name(["ruby"])
rescue ActsAsTaggableOn::DuplicateTagError => e
  e.message.upcase
end

cloud = TagCloudHelper.new
cloud.tag_cloud(ActsAsTaggableOn::Tag.most_used, %w[css1 css2]) do |t, css_class|
  t.name.upcase
  css_class.upcase
end
cloud.tag_cloud([tag], ["css1"]) { |t, css_class| t.name + css_class }

parser = ActsAsTaggableOn::GenericParser.new("a, b")
parser.parse.first&.upcase
ActsAsTaggableOn::DefaultParser.new(["a", "b"]).parse.first&.upcase
ActsAsTaggableOn::TagList.new("a", "b").first&.upcase
ActsAsTaggableOn::TagList.new.first&.upcase
ActsAsTaggableOn::TagList.new("a, b", parse: true).first&.upcase
