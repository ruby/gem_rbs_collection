require "discard"

class Post < ActiveRecord::Base
  include Discard::Model

  self.discard_column = :deleted_at

  before_discard :check_discardable
  around_discard :wrap_discard
  after_discard { notify_discarded }
  before_undiscard :check_restorable, if: :restorable?
  around_undiscard :wrap_undiscard
  after_undiscard ->(post) { post.notify_discarded }, unless: ->(post) { post.restorable? }

  def check_discardable = nil

  def check_restorable = nil

  def wrap_discard = nil

  def wrap_undiscard = nil

  def notify_discarded = nil

  def restorable? = true
end

class Comment < ActiveRecord::Base
  include Discard::Model

  self.discard_column = "removed_at"

  belongs_to :post, -> { with_discarded }
end

post = Post.new
discarded = post.discarded?
undiscarded = post.undiscarded?
kept = post.kept?
discarded || undiscarded || kept

result = post.discard #: bool
result || post.undiscard
post.discard!.itself
post.undiscard!.itself

column = Post.discard_column #: Symbol | String
column.to_s
Post.discard_column = :discarded_at

kept_posts = Post.kept #: Post::ActiveRecord_Relation
kept_posts.where(id: 1).first
Post.undiscarded.count
Post.discarded.where(id: 1).kept.count
Post.with_discarded.where(id: 1).discarded.count

discarded_posts = Post.kept.where(id: 1).discard_all #: Array[Post]
discarded_posts.first&.kept?
Post.kept.discard_all!.first&.discarded?
Post.discarded.undiscard_all.first&.kept?
Post.discarded.undiscard_all!.first&.kept?

begin
  post.discard!
rescue Discard::RecordNotDiscarded => e
  record = e.record #: ActiveRecord::Base?
  record&.id
  e.message
end

begin
  post.undiscard!
rescue Discard::RecordNotUndiscarded => e
  record = e.record #: ActiveRecord::Base?
  record&.id
rescue Discard::DiscardError => e
  e.message
end

Discard::VERSION.upcase
