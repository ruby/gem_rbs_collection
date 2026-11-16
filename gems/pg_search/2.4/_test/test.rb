require "pg_search"

class Post < ActiveRecord::Base
  include PgSearch::Model

  pg_search_scope :search_by_title, against: :title

  pg_search_scope :search_by_content,
    against: {title: "A", body: "B"},
    associated_against: {comments: [:body], author: {name: "C"}},
    using: {
      tsearch: {
        dictionary: "english",
        prefix: true,
        negation: true,
        any_word: false,
        normalization: 2,
        tsvector_column: :searchable,
        highlight: {StartSel: "<mark>", StopSel: "</mark>", MaxFragments: 2}
      },
      trigram: {threshold: 0.3, word_similarity: true, only: [:title]},
      dmetaphone: {tsvector_column: ["title_tsv"], sort_only: :body}
    },
    ignoring: :accents,
    ranked_by: ":tsearch + (0.5 * :trigram)",
    order_within_rank: "posts.updated_at DESC"

  pg_search_scope :search_by_pair, against: [[:title, "A"], :body], using: [:tsearch, :trigram], ignoring: [:accents]

  scope_options = {against: :title, order_within_rank: nil}
  pg_search_scope :search_nil_order, scope_options

  pg_search_scope :search_dynamic, ->(query) { {query: query, against: :title, using: :dmetaphone} }

  pg_search_scope :search_proc, lambda { |query, limit|
    {query: "#{query} #{limit}", against: [:title, :body]}
  }

  multisearchable against: [:title, :body],
    if: :published?,
    unless: ->(_post) { false },
    update_if: [:saved_change_to_title?, proc { true }],
    additional_attributes: ->(_post) { {author_id: 1} }

  def self.rank_of_first
    search_by_title("ruby").with_pg_search_rank.first&.pg_search_rank
  end

  def published? = true

end

class Tag < ActiveRecord::Base
  include PgSearch::Model
end

class Comment < ActiveRecord::Base
  include PgSearch::Model

  multisearchable
  multisearchable against: :body, additional_attributes: :attrs_for_document
  document_options = {against: :body}
  multisearchable document_options
  multisearchable(
    against: [:body],
    if: [:visible?, ->(_comment) { true }],
    additional_attributes: proc { |_comment| {topic_id: 1} }
  )

  def update_pg_search_document
    PgSearch::Document.where(searchable: self).delete_all
  end

  def attrs_for_document = {}

  def visible? = true
end

post = Post.new

relation = Post.search_by_title("ruby").with_pg_search_rank #: Post::ActiveRecord_Relation
relation.first&.title
highlighted = Post.search_by_content("ruby").with_pg_search_highlight.with_pg_search_rank #: Post::ActiveRecord_Relation
highlighted.to_a.each do |found|
  rank = found.pg_search_rank #: Float
  rank.round(2)
  found.pg_search_highlight.upcase
end

PgSearch.multisearch_options = {using: {tsearch: {prefix: true}}, ignoring: :accents}
PgSearch.multisearch_options = ->(query) { {query: query, against: :content} }
PgSearch.multisearch_options = {}
multisearch_defaults = {using: [:tsearch]}
PgSearch.multisearch_options = multisearch_defaults
PgSearch.multisearch_options.itself
PgSearch.unaccent_function = "my_unaccent"
PgSearch.unaccent_function.upcase

documents = PgSearch.multisearch("ruby") #: PgSearch::Document::ActiveRecord_Relation
documents.where(searchable_type: "Post").limit(10).to_a
PgSearch.multisearch("ruby").includes(:searchable).reorder("").to_a

document = PgSearch::Document.search("ruby").first
if document
  content = document.content #: String
  content.upcase
  document.searchable_type.upcase
  document.searchable_id.succ
  searchable = document.searchable #: ActiveRecord::Base
  searchable.itself
  document.searchable = post
end

stored = post.pg_search_document #: PgSearch::Document?
stored&.content
post.update_pg_search_document

result = PgSearch.disable_multisearch { post.save } #: bool
result || PgSearch.multisearch_enabled?

PgSearch::Multisearch.rebuild(Post)
PgSearch::Multisearch.rebuild(Post, clean_up: false, transactional: false)

begin
  post.pg_search_rank
rescue PgSearch::PgSearchRankNotSelected => e
  e.message.upcase
end

begin
  post.pg_search_highlight
rescue PgSearch::PgSearchHighlightNotSelected => e
  e.message.upcase
end

begin
  PgSearch::Multisearch.rebuild(Tag)
rescue PgSearch::Multisearch::ModelNotMultisearchable => e
  e.message.upcase
end

PgSearch::VERSION.upcase
