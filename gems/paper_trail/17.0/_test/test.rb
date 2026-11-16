require "paper_trail"
require "action_controller"

class Article < ActiveRecord::Base
  has_paper_trail
end

module PageTitle
  def self.of(page)
    record = page #: Page
    record.title
  end
end

class Page < ActiveRecord::Base
  has_paper_trail(
    on: [:update, :destroy],
    only: [:title, :body],
    ignore: [:updated_at, { status: proc { |page| PageTitle.of(page).empty? } }],
    skip: %w[token],
    if: ->(page) { PageTitle.of(page).size > 0 },
    unless: proc { |page| PageTitle.of(page) == "draft" },
    meta: { slug: proc { |page| PageTitle.of(page).downcase }, editor: "web" },
    versions: { name: :page_versions, class_name: "PaperTrail::Version" },
    version: :paper_trail_version,
    synchronize_version_creation_timestamp: false
  )

  def title = "draft"
end

class Note < ActiveRecord::Base
  has_paper_trail on: :create, versions: { name: :note_versions, class_name: "PaperTrail::Version" }

  paper_trail.on_destroy(:after)
  paper_trail.on_update
  paper_trail.on_create
  paper_trail.on_touch
end

class Memo < ActiveRecord::Base
  has_paper_trail
  paper_trail.on_destroy
end

class ArticleVersion < PaperTrail::Version
end

class ApiController < ActionController::API
  before_action :set_paper_trail_whodunnit

  def user_for_paper_trail
    "api"
  end
end

class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit

  def user_for_paper_trail
    current_user_id
  end

  def info_for_paper_trail
    { remote_ip: request.remote_ip, request_path: request.path }
  end

  def paper_trail_enabled_for_controller
    super && request.user_agent != "bot"
  end

  def current_user_id
    1
  end

  def prepare_request
    set_paper_trail_whodunnit
  end
end

Note.new.note_versions.last&.reify
Page.new.page_versions.size

article = Article.new
article.paper_trail_event = "published"
event = article.paper_trail_event
event&.upcase

trail = article.paper_trail
live = trail.live?
live ? 1 : 0
current = trail.version_at(Time.now)
current&.id
trail.version_at(Date.today, { dup: true, unversioned_attributes: :preserve })
trail.previous_version&.id
trail.next_version&.id
originator = trail.originator
originator&.upcase
trail.update_column(:title, "new")
trail.update_columns({ title: "new", body: "text" })
saved = trail.save_with_version(validate: false)
saved ? 1 : 0
trail.save_with_version(in_after_callback: true)
history = trail.versions_between(Time.now - 3600, Time.now)
history.compact.map(&:id)

article.versions.reorder(created_at: :desc)
article.versions.first&.event&.upcase
article.versions.last&.reify&.id
article.versions.where(event: "update").between(Time.now - 60, Time.now).count

Article.paper_trail_options[:only]
Article.paper_trail.on_update

version = PaperTrail::Version.find(1)
version_event = version.event
version_event.upcase
type = version.item_type
type.upcase
item_id = version.item_id
item_id.to_s
who = version.whodunnit
who&.to_i
version.created_at.year
version.object
version.object_changes
version.reify&.id
version.reify({ mark_for_destruction: true, dup: true })
changes = version.changeset
changes&.keys&.first&.upcase
originator_of_version = version.paper_trail_originator
originator_of_version&.upcase
version.terminator&.upcase
version.version_author&.upcase
version.next&.event&.upcase
version.previous&.event&.upcase
version.index + 1
version.item&.id

PaperTrail::Version.with_item_keys("Article", 1).updates.destroys.creates.not_creates
PaperTrail::Version.between(Time.now - 60, Time.now)
PaperTrail::Version.between(Date.today, Date.today + 1)
order = PaperTrail::Version.timestamp_sort_order("desc")
order.size
PaperTrail::Version.timestamp_sort_order
PaperTrail::Version.where_attribute_changes(:title)
PaperTrail::Version.where_object(title: "x")
PaperTrail::Version.where_object
PaperTrail::Version.where_object_changes(title: "x", "body" => "y")
PaperTrail::Version.where_object_changes_from(title: "x")
PaperTrail::Version.where_object_changes_to(title: "y")
PaperTrail::Version.preceding(version).limit(1)
PaperTrail::Version.subsequent(version, false)
PaperTrail::Version.subsequent(Time.now, true).first
PaperTrail::Version.where(item_type: "Article", item_id: 1).order(:id).pluck(:object_changes)
ArticleVersion.new.item

PaperTrail.enabled = false
PaperTrail.enabled = true
enabled = PaperTrail.enabled?
enabled ? 1 : 0
PaperTrail.gem_version >= Gem::Version.new("17.0")
PaperTrail.version.upcase
PaperTrail::VERSION::STRING.upcase
PaperTrail::VERSION::MAJOR + PaperTrail::VERSION::MINOR + PaperTrail::VERSION::TINY
PaperTrail::VERSION::PRE&.upcase
PaperTrail::VERSION.to_s.upcase

PaperTrail.request.whodunnit = "admin"
PaperTrail.request.whodunnit = 42
PaperTrail.request.whodunnit = -> { "dynamic" }
PaperTrail.request.whodunnit = nil
PaperTrail.request.whodunnit
PaperTrail.request.controller_info = { ip: "127.0.0.1" }
info = PaperTrail.request.controller_info
info&.keys
PaperTrail.request.enabled = false
request_enabled = PaperTrail.request.enabled?
request_enabled ? 1 : 0
PaperTrail.request.enable_model(Article)
PaperTrail.request.disable_model(Article)
PaperTrail.request.enabled_for_model(Article, false)
model_enabled = PaperTrail.request.enabled_for_model?(Article)
model_enabled ? 1 : 0

count = PaperTrail.request(enabled: false) { 1 }
count + 1
PaperTrail.request(whodunnit: 3) { Article.new.save }
PaperTrail.request(whodunnit: "user", controller_info: { ip: "1.2.3.4" }, enabled: true) { Article.create! }

PaperTrail.config.enabled = false
PaperTrail.config.enabled
PaperTrail.config.serializer = PaperTrail::Serializers::JSON
PaperTrail.config.serializer = PaperTrail::Serializers::YAML
PaperTrail.config.serializer.load("{}")
PaperTrail.config.serializer.dump({ "a" => 1 }).upcase
PaperTrail.config.version_limit = 10
PaperTrail.config.version_limit = nil
PaperTrail.config.version_limit
PaperTrail.config.version_error_behavior = :log
PaperTrail.config.version_error_behavior
PaperTrail.config.association_reify_error_behaviour = :warn
PaperTrail.config.association_reify_error_behaviour
PaperTrail.config.object_changes_adapter = Object.new
PaperTrail.config.object_changes_adapter
PaperTrail.config.has_paper_trail_defaults = { on: [:create, :update] }
PaperTrail.config.has_paper_trail_defaults.keys
PaperTrail::Config.instance.enabled

PaperTrail.config do |config|
  config.enabled = true
  config.version_limit = 5
end
PaperTrail.configure do |config|
  config.version_limit = 20
end
PaperTrail.serializer = PaperTrail::Serializers::JSON
PaperTrail.serializer.load("{}")
PaperTrail.serializer.dump({ "a" => 1 })
PaperTrail::Serializers::JSON.load("{}")
PaperTrail::Serializers::JSON.dump({ "a" => 1 }).upcase
PaperTrail::Serializers::YAML.load("--- {}")
PaperTrail::Serializers::YAML.dump({ "a" => 1 }).upcase

PaperTrail.clean_versions!
PaperTrail.clean_versions!(keeping: 2, date: Date.today, item_id: 5)
PaperTrail.clean_versions!(date: :all)

begin
  Article.new.save!
rescue PaperTrail::UnsupportedColumnType, PaperTrail::UnsupportedSchema, PaperTrail::InvalidOption, PaperTrail::Error => e
  e.message.upcase
end
