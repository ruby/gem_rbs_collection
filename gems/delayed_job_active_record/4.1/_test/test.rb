configuration = Delayed::Backend::ActiveRecord.configuration
configuration.reserve_sql_strategy = :default_sql
configuration.reserve_sql_strategy = :optimized_sql
