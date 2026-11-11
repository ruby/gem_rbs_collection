# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

# Configuration class attributes hold the values Rails documents
ActiveRecord::Base.table_name_prefix.upcase
ActiveRecord::Base.table_name_suffix.upcase
ActiveRecord::Base.schema_migrations_table_name.upcase
ActiveRecord::Base.internal_metadata_table_name.upcase
ActiveRecord::Base.inheritance_column.upcase
ActiveRecord::Base.inheritance_column = nil
ActiveRecord::Base.cache_timestamp_format.to_proc
ActiveRecord::Base.attribute_aliases.each { |new_name, old_name| new_name.upcase + old_name.upcase }
ActiveRecord::Base.aggregate_reflections.each_key(&:upcase)
ActiveRecord::Base.default_scopes.map(&:scope)
ActiveRecord::Base.nested_attributes_options.each_value { |options| options.key?(:allow_destroy) }
ActiveRecord::Base.skip_time_zone_conversion_for_attributes.map(&:to_proc)
ActiveRecord::Base.time_zone_aware_types.map(&:to_proc)
ActiveRecord::Base.record_timestamps = !ActiveRecord::Base.lock_optimistically
ActiveRecord::Base.enumerate_columns_in_select_statements = !ActiveRecord::Base.cache_versioning
ActiveRecord::Base.new.record_timestamps = !ActiveRecord::Base.new.pluralize_table_names
ActiveRecord::Base.attribute_method_matchers.map(&:prefix)
