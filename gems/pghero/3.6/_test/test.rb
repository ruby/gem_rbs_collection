require "rails"
require "active_record"
require "pghero"

PgHero.long_running_query_sec = 120
PgHero.slow_query_ms = 50
PgHero.slow_query_calls = 200
PgHero.explain_timeout_sec = 5
PgHero.total_connections_threshold = 300
PgHero.cache_hit_rate_threshold = 98
PgHero.show_migrations = false
PgHero.config_path = "config/pghero.yml"
PgHero.env = "production"
PgHero.filter_data = true
PgHero.time_zone = "Tokyo"
PgHero.time_zone = ActiveSupport::TimeZone.new("UTC")

# @type var long_running: Integer
long_running = PgHero.long_running_query_sec
long_running + PgHero.slow_query_ms + PgHero.slow_query_calls
PgHero.explain_timeout_sec.floor
PgHero.total_connections_threshold + PgHero.cache_hit_rate_threshold
PgHero.show_migrations ? 1 : 0
PgHero.config_path.upcase
PgHero.env.upcase
PgHero.filter_data ? 1 : 0
PgHero.time_zone.nil?
PgHero.username&.upcase
PgHero.password&.upcase
PgHero.stats_database_url&.upcase
PgHero.visualize_url.upcase
PgHero::VERSION.upcase

# @type var config: Hash[String, untyped]
config = PgHero.config

PgHero.capture_query_stats
PgHero.capture_query_stats(verbose: true)
PgHero.capture_space_stats(verbose: true)
PgHero.analyze_all(verbose: true, min_size: 1024, tables: ["users"])
PgHero.analyze_all(tables: "users")
PgHero.autoindex_all(create: false, verbose: false)
PgHero.clean_query_stats
PgHero.clean_query_stats(before: Time.now - 86400)
PgHero.clean_space_stats(before: Time.now - 86400)
PgHero.pretty_size(1024).upcase

# @type var databases: Hash[Symbol, PgHero::Database]
databases = PgHero.databases
databases.each do |id, database|
  id.to_proc
  database.id.upcase
  database.name.upcase
end

PgHero::Engine.ancestors.size

configure_controller = lambda do
  PgHero::HomeController.content_security_policy do |policy|
    policy
  end
  PgHero::HomeController.after_action do
    nil
  end
end
configure_controller.arity

begin
  raise PgHero::NotEnabled, "disabled"
rescue PgHero::Error => e
  e.message.upcase
end

# @type var database: PgHero::Database
database = PgHero.databases.fetch(:primary)

database.id.upcase
database.config.fetch("url")
database.name.upcase
database.capture_query_stats? ? 1 : 0
database.cache_hit_rate_threshold + database.total_connections_threshold
database.slow_query_ms + database.slow_query_calls + database.long_running_query_sec
database.explain_timeout_sec.floor
database.index_bloat_bytes

database.ssl_used? ? 1 : 0
database.database_name.upcase
database.current_user.upcase
database.server_version.upcase
database.server_version_num + 1
database.quote_ident("users").upcase

# @type var stats: Array[Hash[Symbol, untyped]]
stats = database.query_stats(historical: true, start_at: Time.now - 3600, end_at: Time.now, sort: "calls", query_hash: 1, min_average_time: 5, min_calls: 2)
stats = database.query_stats
slow = database.slow_queries(query_stats: stats)
slow = database.slow_queries(historical: true, sort: "average_time")
stats = database.query_stats(sort: "total_minutes")
stats = database.query_stats(sort: nil)
slow.first&.fetch(:query)
database.query_stats_available? ? 1 : 0
database.query_stats_enabled? ? 1 : 0
database.query_stats_extension_enabled? ? 1 : 0
database.query_stats_readable? ? 1 : 0
database.enable_query_stats
database.disable_query_stats
database.reset_query_stats(user: "app", query_hash: "1", raise_errors: true) ? 1 : 0
database.reset_query_stats
database.historical_query_stats_enabled? ? 1 : 0
database.capture_query_stats(raise_errors: true)
database.clean_query_stats(before: Time.now - 86400) + 1

database.connections.first&.fetch(:pid)
database.total_connections + 1
database.connection_states.fetch("active") + 1
database.connection_sources.first&.fetch(:source)
database.invalid_constraints.first&.fetch(:table)
database.explain("SELECT 1").upcase
database.explain_v2("SELECT 1", analyze: true, verbose: false, format: "json").upcase
database.explain_v2("SELECT 1", format: "yaml")
database.explain_v2("SELECT 1", format: "text")
database.explain_v2("SELECT 1", format: "xml")

database.index_hit_rate&.positive?
database.index_caching.first&.fetch(:hit_rate)
database.index_usage.first&.fetch(:table)
database.missing_indexes.first&.fetch(:table)
database.unused_indexes(max_scans: 10, across: ["primary"]).first&.fetch(:index)
database.reset_stats
database.last_stats_reset_time&.year
database.invalid_indexes.first&.fetch(:index)
database.indexes.first&.fetch(:index)
database.duplicate_indexes(indexes: database.indexes).first&.fetch(:unneeded_index)
database.index_bloat(min_size: 1024).first&.fetch(:index)

database.kill(123) ? 1 : 0
database.kill_long_running_queries(min_duration: 30)
database.kill_all

database.transaction_id_danger(threshold: 100, max_value: 1000).first&.fetch(:table)
database.autovacuum_danger.first&.fetch(:table)
database.vacuum_progress.first&.fetch(:table)
database.maintenance_info.first&.fetch(:table)
database.analyze("users", verbose: true)
database.analyze_tables(verbose: true, min_size: 1024, tables: "users").first&.fetch(:success)
database.analyze_tables(tables: ["users"])

database.running_queries(min_duration: 10, all: true).first&.fetch(:query)
database.long_running_queries.first&.fetch(:query)
database.blocked_queries.first&.fetch(:blocked_pid)

database.replica? ? 1 : 0
database.replication_lag&.positive?
database.replication_slots.first&.fetch(:slot_name)
database.replicating? ? 1 : 0

database.sequences.first&.fetch(:sequence)
database.sequence_danger(threshold: 1, sequences: database.sequences)
database.sequence_danger(threshold: 0.5, sequences: database.sequences).first&.fetch(:sequence)
database.settings.fetch(:max_connections)
database.autovacuum_settings.fetch(:autovacuum)
database.vacuum_settings.fetch(:vacuum_cost_limit)

database.database_size.upcase
database.relation_sizes.first&.fetch(:relation)
database.table_sizes.first&.fetch(:table)
database.space_growth(days: 3, relation_sizes: database.relation_sizes).first&.fetch(:relation)
database.relation_space_stats("users", schema: "public").first&.fetch(:size_bytes)
database.capture_space_stats
database.clean_space_stats(before: Time.now - 86400) + 1
database.space_stats_enabled? ? 1 : 0

database.table_hit_rate&.positive?
database.table_caching.first&.fetch(:table)
database.unused_tables.first&.fetch(:table)
database.table_stats(schema: "public", table: ["users"]).first&.fetch(:table)

PgHero::QueryStats.table_name.upcase
PgHero::SpaceStats.table_name.upcase
PgHero::Stats.abstract_class?

# Delegators to the primary database (removed in 4.0)
# @type var primary_stats: Array[Hash[Symbol, untyped]]
primary_stats = PgHero.query_stats(historical: true, start_at: Time.now - 3600, sort: "average_time")
PgHero.slow_queries(query_stats: primary_stats).first&.fetch(:query)
PgHero.slow_queries(sort: "calls")
PgHero.query_stats_enabled? ? 1 : 0
PgHero.historical_query_stats_enabled? ? 1 : 0
PgHero.database_size.upcase
PgHero.total_connections + 1
PgHero.running_queries.first&.fetch(:query)
PgHero.long_running_queries.first&.fetch(:query)
PgHero.blocked_queries.first&.fetch(:blocked_pid)
PgHero.index_hit_rate&.positive?
PgHero.table_hit_rate&.positive?
PgHero.index_usage.first&.fetch(:table)
PgHero.unused_indexes(max_scans: 10, across: ["primary"]).first&.fetch(:index)
PgHero.unused_tables.first&.fetch(:table)
PgHero.invalid_indexes.first&.fetch(:index)
PgHero.duplicate_indexes(indexes: []).first&.fetch(:unneeded_index)
PgHero.sequence_danger(threshold: 0.5).first&.fetch(:sequence)
PgHero.transaction_id_danger(threshold: 100, max_value: 1000).first&.fetch(:table)
PgHero.autovacuum_danger.first&.fetch(:table)
PgHero.relation_sizes.first&.fetch(:relation)
PgHero.maintenance_info.first&.fetch(:table)
PgHero.replica? ? 1 : 0
PgHero.replication_lag&.positive?
PgHero.last_stats_reset_time&.year
PgHero.settings.fetch(:max_connections)
