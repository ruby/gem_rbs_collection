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
ActiveRecord::Base.nested_attributes_options.each_value { |options| options.key?(:allow_destroy) }
ActiveRecord::Base.skip_time_zone_conversion_for_attributes.map(&:to_proc)
ActiveRecord::Base.time_zone_aware_types.map(&:to_proc)
ActiveRecord::Base.record_timestamps = !ActiveRecord::Base.lock_optimistically
ActiveRecord::Base.new.record_timestamps = !ActiveRecord::Base.new.pluralize_table_names
ActiveRecord::Base.attribute_method_matchers.map(&:prefix)

# Bulk relation methods return the destroyed records or the affected row count
Post.destroy_all.first&.new_record?
Post.destroy_by(id: 1).first&.new_record?
Post.where(id: 1).destroy_by(title: "x").first&.new_record?
Post.delete_all.zero?
Post.delete_by(id: 1).zero?
Post.update_all(title: "x").zero?
Post.touch_all(time: Time.now).zero?
Post.where(id: 1).delete_all.zero?
Post.where(id: 1).delete_by(title: "x").zero?
Post.where(id: 1).update_all(title: "x").zero?
Post.where(id: 1).touch_all.zero?

# The same through the _ActiveRecord_Relation interfaces
Comment.destroy_all.first&.new_record?
Comment.destroy_by(id: 1).first&.new_record?
Comment.where(id: 1).destroy_by(title: "x").first&.new_record?
Comment.delete_all.zero?
Comment.delete_by(id: 1).zero?
Comment.update_all(title: "x").zero?
Comment.touch_all(time: Time.now).zero?
Comment.where(id: 1).delete_all.zero?
Comment.where(id: 1).delete_by(title: "x").zero?
Comment.where(id: 1).update_all(title: "x").zero?
Comment.where(id: 1).touch_all.zero?
