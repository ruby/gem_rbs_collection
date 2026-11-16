require "active_record_union"

class Post < ActiveRecord::Base
end

# Relations are taken as arguments, so nothing here needs a database
class UnionExamples
  def combine(recent, featured, pinned)
    # @type var combined: Post::ActiveRecord_Relation
    combined = recent.union(featured)
    combined = combined.order(created_at: :desc)
    combined = recent.union(featured).union(pinned)

    # @type var with_hash: Post::ActiveRecord_Relation
    with_hash = recent.union(author_id: 1)
    with_hash = recent.union("title LIKE ?", "%rbs%")
    with_hash = recent.union(["title = ?", "rbs"])

    # @type var all_posts: Post::ActiveRecord_Relation
    all_posts = recent.union_all(featured)
    all_posts = all_posts.where.not(id: nil).order(:id)
    all_posts = recent.union_all(author_id: 2)
    all_posts = recent.union_all("title = :title", { title: "rbs" })

    # @type var injected: Post::ActiveRecord_Relation
    injected = [recent, featured, pinned].inject { |merged, relation| merged.union(relation) }

    ::ActiveRecord::Relation.include?(::ActiveRecord::Relation::Union)

    [combined, with_hash, all_posts, injected]
  end
end
