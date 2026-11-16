require "opensearch"
require "opensearch/dsl"

# These calls connect to a cluster, so they are type checked but never run.
# @type var use_client: ^() -> void
use_client = -> do
  client = OpenSearch::Client.new(
    host: "https://localhost:9200",
    user: ENV.fetch("OPENSEARCH_USER"),
    password: ENV.fetch("OPENSEARCH_PASSWORD"),
    transport_options: { ssl: { ca_file: "/etc/ssl/certs/opensearch-ca.pem" } }
  )

  url_client = OpenSearch::Client.new(url: "http://localhost:9200", log: true, retry_on_failure: 3)
  hosts_client = OpenSearch::Client.new(hosts: ["a:9200", "b:9200"], request_timeout: 5)
  faraday_client = OpenSearch::Client.new(url: "http://localhost:9200") do |f|
    f.request :url_encoded
  end

  index_name = "test-index"

  # Index lifecycle
  created = client.indices.create(index: index_name, body: { settings: { index: { number_of_shards: 4 } } })
  created["acknowledged"]

  exists = client.indices.exists(index: index_name)
  exists_alias_style = client.indices.exists?(index: index_name)
  exists || exists_alias_style

  client.indices.put_mapping(index: index_name, body: { properties: { title: { type: "text" } } })
  mapping = client.indices.get_mapping(index: index_name)
  mapping.keys
  client.indices.put_settings(index: index_name, body: { index: { refresh_interval: "1s" } })
  client.indices.get_settings(index: index_name).keys
  client.indices.get(index: index_name).keys
  client.indices.refresh(index: index_name).keys
  client.indices.flush(index: index_name).keys
  client.indices.close(index: index_name).keys
  client.indices.open(index: index_name).keys
  client.indices.analyze(body: { analyzer: "standard", text: "Hello" }).keys
  client.indices.stats(index: index_name).keys
  client.indices.put_alias(index: index_name, name: "test-alias")
  client.indices.get_alias(name: "test-alias").keys
  alias_exists = client.indices.exists_alias(name: "test-alias")
  alias_exists_q = client.indices.exists_alias?(name: "test-alias")
  alias_exists || alias_exists_q
  client.indices.update_aliases(body: { actions: [{ add: { index: index_name, alias: "other" } }] })
  client.indices.delete_alias(index: index_name, name: "other")

  # Documents
  indexed = client.index(index: index_name, body: { title: "Moneyball" }, id: "1", refresh: true)
  indexed["result"]
  client.create(index: index_name, id: "2", body: { title: "Other" }).keys
  doc = client.get(index: index_name, id: "1")
  doc["_source"]
  doc_exists = client.exists(index: index_name, id: "1")
  doc_exists_q = client.exists?(index: index_name, id: "1")
  doc_exists || doc_exists_q
  client.update(index: index_name, id: "1", body: { doc: { title: "Updated" } }).keys
  client.mget(index: index_name, body: { ids: ["1", "2"] }).keys
  client.bulk(body: [{ index: { _index: index_name, _id: "3" } }, { title: "Bulk" }]).keys
  client.bulk.keys
  client.delete(index: index_name, id: "1").keys

  # Search
  response = client.search(
    index: index_name,
    body: { size: 5, query: { multi_match: { query: "miller", fields: ["title^2", "director"] } } },
    timeout: "5s",
    allow_partial_search_results: false
  )
  # @type var hits: Hash[String, untyped]
  hits = response["hits"]
  # @type var hit_list: Array[Hash[String, untyped]]
  hit_list = hits["hits"]
  hit_list.size
  client.search.keys
  client.count(index: index_name).keys
  client.msearch(body: [{ index: index_name }, { query: { match_all: { boost: 1 } } }]).keys
  client.scroll(scroll_id: "id", scroll: "1m").keys
  client.clear_scroll(scroll_id: "id").keys
  client.update_by_query(index: index_name, body: { script: { source: "ctx._source.a = 1" } }).keys
  client.delete_by_query(index: index_name, body: { query: { match_all: { boost: 1 } } }).keys
  client.reindex(body: { source: { index: "a" }, dest: { index: "b" } }).keys

  # Cluster
  client.cluster.health.keys
  client.cluster.health(index: index_name, wait_for_status: "yellow").keys
  client.cluster.state.keys
  client.cluster.stats.keys
  client.cluster.get_settings.keys
  client.cluster.put_settings(body: { transient: { "cluster.max_shards_per_node" => 1000 } }).keys
  client.info["version"]
  alive = client.ping
  alive ? 1 : 0
  client.indices.delete(index: index_name)

  # Errors
  begin
    client.delete(index: index_name, id: "1")
  rescue OpenSearch::Transport::Transport::Errors::NotFound => e
    e.message
  rescue OpenSearch::Transport::Transport::Errors::Conflict, OpenSearch::Transport::Transport::Errors::BadRequest => e
    e.message
  rescue OpenSearch::Transport::Transport::ServerError => e
    e.message
  rescue OpenSearch::Transport::Transport::Error => e
    e.message
  end
end

error_class = OpenSearch::Transport::Transport::Errors::ServiceUnavailable
error_class.new.is_a?(OpenSearch::Transport::Transport::ServerError)
OpenSearch::UnsupportedProductError.new.message
OpenSearch::VERSION.length

# API settings and serializer
serializer = OpenSearch::Transport::Transport::Serializer::MultiJson.new
OpenSearch::API.settings[:serializer] = serializer
serializer.load("{}")
serializer.dump({ "a" => 1 }, { pretty: true }).length

# DSL
product = "ruby"
tags = ["a", "b"]

definition = OpenSearch::DSL::Search.search do
  size 10
  from 5
  source ["title", "tags"]

  query do
    function_score do
      query do
        bool do
          should do
            query_string do
              query product
              fields ["title^3", "body"]
              default_operator "or"
              minimum_should_match "50%"
            end
          end

          should do
            prefix "title.raw" do
              value product
              boost 4
            end
          end

          should { match title: product }
          must do
            multi_match do
              query product
              fields ["title", "tags"]
              operator "and"
            end
          end
          must_not { term draft: true }
          must { terms tags: tags }
          must do
            range :published_at do
              gte "2020-01-01"
              lt "now"
            end
          end

          minimum_should_match 1
          boost 2
          filter { term published: true }
          filter do
            exists field: "title"
          end
        end
      end

      boost_mode "sum"
      score_mode "multiply"
      max_boost 5
      functions << { field_value_factor: { field: :views, modifier: :log1p } }
      functions.size
      self.functions = [{ weight: 2 }]
    end
  end

  filter do
    bool do
      must { term kind: "gem" }
      should { terms tags: tags }
    end
  end

  post_filter { range(:views) { gte 10 } }

  aggregation :by_tag do
    terms do
      field "tags"
      size 20
      order "_count" => "desc"
    end
  end

  aggregation :tag_buckets do
    filters do
      filters first: { terms: { tags: ["a"] } }, second: { term: { tags: "b" } }
    end
  end

  aggregation :recent do
    date_range do
      field "created_at"
      format "yyyy-MM-dd"
      ranges [{ from: "now-1d/d", to: "now" }]
    end
  end

  aggregation :views_range do
    range do
      field "views"
      key "low", { to: 10 }
    end
  end

  aggregation :per_author do
    terms field: "author" do
      aggregation :avg_views do
        avg field: "views"
      end
    end
  end

  aggregation :total, { sum: { field: "views" } }

  highlight do
    fields title: {}
    field :body, fragment_size: 100
    pre_tags "<em>"
    post_tags "</em>"
  end

  sort do
    by :published_at, "desc"
    by "_score"
  end

  suggest :title_suggest, text: product, term: { field: "title" }
  explain true
end
definition.to_hash[:size]
definition.query&.to_hash
definition.size.to_i
definition.from.to_i
definition.suggest

block_arg = OpenSearch::DSL::Search.search { |s| s.size(3) }
block_arg.to_hash

dsl_query = OpenSearch::DSL::Search.search
dsl_query.query { match_all }
dsl_query.query { |q| q.match title: product }
dsl_query.query { term kind: "gem" }
dsl_query.filter { term kind: "gem" }
dsl_query.filter { |f| f.terms tags: tags }
dsl_query.filter { bool { should { term kind: "gem" } } }
dsl_query.filter { match_all }
dsl_query.filter { query { match_all } }
dsl_query.aggregation(:x) { terms field: "tags" }
dsl_query.highlight { fields ["title"] }
dsl_query.highlight { |h| h.field(:title) }
dsl_query.sort { by :a }
dsl_query.sort :a, :b
dsl_query.suggest(:s, { text: "a" }) { }
dsl_query.query = { match_all: {} }
dsl_query.size = 3
dsl_query.from = 1
dsl_query.sort = [:a]
dsl_query.aggregations&.to_hash
dsl_query.to_hash

# @type var use_dsl: ^() -> void
use_dsl = -> do
  client = OpenSearch::Client.new(url: "http://localhost:9200")
  client.search(index: "test-index", body: dsl_query.to_hash).keys
end

definition.filter
definition.post_filter
# @type var sort_items: Array[untyped]
sort_items = definition.sort&.to_hash || []
sort_items.first
definition.highlight
definition.stored_fields
definition.aggregations
OpenSearch::DSL::Search::Search.new(size: 1).to_hash

class SearchBuilder
  include OpenSearch::DSL::Search

  def build
    search { size 2 }
  end
end
SearchBuilder.new.build.to_hash
