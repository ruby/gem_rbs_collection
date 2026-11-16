require "friendly_id"

FriendlyId.defaults do |config|
  config.use :reserved
  config.reserved_words = %w[new edit index admin]
  config.use :finders
  config.slug_column = :permalink
  config.slug_limit = 100
  config.sequence_separator = "--"
  config.treat_numeric_as_conflict = true
  config.treat_reserved_as_conflict = true
  config.routes = :friendly
  config.dependent = :destroy
  config.slug_generator_class = FriendlyId::SlugGenerator
end

class Article < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: :slugged

  def title = "Hello"

  def title_changed? = false

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def normalize_friendly_id(value)
    super(value.downcase)
  end

  def resolve_friendly_id_conflict(candidates)
    candidates.each { |candidate| candidate.upcase }
    first = candidates.each.first #: String?
    first && "#{first}-copy"
  end
end

FRIENDLY_OPTIONS = { use: :slugged, slug_column: :slug }

class Post < ActiveRecord::Base
  extend FriendlyId

  friendly_id :slug_candidates, use: [:slugged, :history, :finders, :scoped], scope: [:blog, "category"], slug_column: :slug, slug_limit: 80, dependent: :nullify

  def slug = "post"

  def slug_candidates
    [:title, [:title, :id]]
  end
end

class Page < ActiveRecord::Base
  extend FriendlyId

  friendly_id { |config| config.routes = false }

  friendly_id(:name, use: %i[slugged sequentially_slugged simple_i18n]) do |config|
    config.base = :name
    config.use :history, FriendlyId::Reserved, "finders"
    config.finder_methods = FriendlyId::FinderMethods
    config.scope = :site
    config.reserved_words = nil
  end
end

class Product < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, FRIENDLY_OPTIONS
end

class Account < ActiveRecord::Base
  include FriendlyId

  friendly_id :name, use: nil, routes: :default, finder_methods: FriendlyId::FinderMethods, sequence_separator: "_", slug_generator_class: FriendlyId::SlugGenerator, treat_numeric_as_conflict: false, reserved_words: ["new"], treat_reserved_as_conflict: true
end

module Lookup
  def self.generator(generator, candidates)
    available = generator.available?("hello") #: bool
    generated = generator.generate(candidates) #: String?
    [available, generated]
  end

  def self.article(param)
    article = Article.friendly.find(param) #: Article
    maybe_article = Article.friendly.find(param, allow_nil: true) #: Article?
    articles = Article.friendly.find([1, 2]) #: Array[Article]
    found = Article.friendly.find_by_friendly_id(param) #: Article
    found.title.upcase

    exists = Article.friendly.exists?(param) #: bool
    exists_by_slug = Article.friendly.exists_by_friendly_id?(param) #: bool
    return article if maybe_article.nil? || articles.empty? || !exists || !exists_by_slug

    maybe_article
  end

  def self.post(param)
    Post.friendly.find(param).slug.upcase
  end

  def self.config_of
    config = Article.friendly_id_config #: FriendlyId::Configuration
    class_config = Post.friendly_id_config
    base = config.base #: (Symbol | String)?
    class_config.base(:title).to_s
    class_config.dependent_value
    config.use(:slugged, FriendlyId::History)
    uses = config.uses?(:history) #: bool?
    column = config.slug_column #: (Symbol | String)
    separator = config.sequence_separator #: String
    limit = config.slug_limit #: Integer?
    reserved = config.reserved_words #: Array[String]?
    scope_columns = config.scope_columns #: Array[String]
    modules = config.modules #: Array[Module]
    defaults = config.defaults #: Hash[Symbol, untyped]
    klass = config.model_class #: Class
    config.query_field.to_s.upcase
    config.dependent
    config.routes
    config.finder_methods
    [base, uses, column, separator, limit, reserved, scope_columns, modules, defaults, klass, config.slug_generator_class, config.treat_numeric_as_conflict, config.treat_reserved_as_conflict, config.scope]
  end

  def self.record(post)
    id = post.friendly_id #: String?
    param = post.to_param #: String?
    history = post.slugs #: ActiveRecord::Associations::CollectionProxy
    slug = FriendlyId::Slug.new
    slug.slug = "hello"
    slug.scope = nil
    slug.sluggable_type = "Post"
    slug.sluggable_id = 1
    owner = slug.sluggable #: ActiveRecord::Base?
    slug_param = slug.to_param #: String
    [id, param, history, owner, slug_param, FriendlyId::VERSION.upcase, FriendlyId.table_name_prefix.upcase]
  end

  def self.generate(article)
    normalized = article.normalize_friendly_id("Hello World") #: String
    instance_config = article.friendly_id_config #: FriendlyId::Configuration
    [normalized, instance_config.dependent, article.should_generate_new_friendly_id?]
  end

  def self.i18n(page)
    page.set_friendly_id("Title", :ja)
    page.set_friendly_id("Title")
  end
end
