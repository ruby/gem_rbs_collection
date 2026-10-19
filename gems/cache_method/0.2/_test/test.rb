require "cache_method"

CacheMethod.config.default_ttl = 120
CacheMethod.config.default_generational_ttl = 0
CacheMethod.config.generational = true
CacheMethod.config.generational?.then { |generational| generational & true }
CacheMethod.config.default_ttl.succ
CacheMethod.digest([1, "two"]).length

class Blog
  def entries(date)
    "entries for #{date}"
  end
  cache_method :entries, 60

  def title
    "Blog"
  end
  cache_method :title

  def update(stuff)
    stuff
  end
  cache_method_clear_on :update, :entries

  def as_cache_key
    { name: "blog" }
  end
end

module Feeds
  def self.latest
    [1, 2, 3]
  end
end

blog = Blog.new
blog.cache_method_clear(:entries)
blog.cache_method_cached?(:entries, "2024-01-01") & true
Blog.cache_method_clear(:entries)
Feeds.cache_method_cached?(:latest) & true
