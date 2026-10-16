# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "activerecord"

module Test
  class ApplicationRecord < ActiveRecord::Base
    primary_abstract_class

    connects_to database: { writing: :primary, reading: :primary_replica }
    connects_to shards: {
      default: { writing: :primary, reading: :primary_replica },
      shard_two: { writing: :primary_shard_two, reading: :primary_shard_replica_two }
    }
  end

  class User < ApplicationRecord
    # @dynamic articles
    has_many :articles

    enum status: { active: 0, inactive: 1 }, _suffix: true
    enum :role, { admin: 0, user: 1 }, _prefix: true
    enum :classify, %w[hoge fuga], _default: "hoge"
    enum :hoge, fuga: 0, piyo: 1

    encrypts :secret, :key
    encrypts :token, deterministic: true
    encrypts :phrase, ignore_case: true

    normalizes :email, with: -> email {
      # @type var email: String
      email.strip.downcase
    }
  end

  class Article < ApplicationRecord
  end

  User.where.missing.to_sql
  User.where(role: :admin).load_async
  User.deterministic_encrypted_attributes
  User.source_attribute_from_preserved_attribute(:phrase)
  User.insert({ id: 1, name: 'James' }, returning: %i[id name], unique_by: :id, record_timestamps: true)
  User.insert!({ id: 1, name: 'James' }, returning: %i[id name], record_timestamps: true)
  User.insert_all([{ id: 1, name: 'James' }], returning: %i[id name], unique_by: :id, record_timestamps: true)
  User.insert_all!([{ id: 1, name: 'James' }], returning: %i[id name], record_timestamps: true)
  User.upsert({ id: 1, name: 'James' }, returning: %i[id name], unique_by: :id, record_timestamps: true)
  User.upsert_all([{ id: 1, name: 'James' }], returning: %i[id name], unique_by: :id, record_timestamps: true)
  User.with(admin_users: User.where(role: 0))
  User.strict_loading
  User.strict_loading(false)
  User.create_with(name: 'name', age: 1)
  User.create_with(nil)
  User.sole.id
  User.all.sole.id
  User.take.articles.sole.id
  User.from('users AS users')
  User.from(User.where(:active), :u)
  user = User.new(secret: 'dummy', key: 'dummy', token: 'dummy', phrase: 'dummy')
  user.encrypt
  user.encrypted_attribute?(:secret)
  user.decrypt
  user.ciphertext_for(:token)
  user.articles.insert({ id: 1, name: 'James' }, returning: %i[id name], unique_by: :id, record_timestamps: true)
  user.articles.insert!({ id: 1, name: 'James' }, returning: %i[id name], record_timestamps: true)
  user.articles.insert_all([{ id: 1, name: 'James' }], returning: %i[id name], unique_by: :id, record_timestamps: true)
  user.articles.insert_all!([{ id: 1, name: 'James' }], returning: %i[id name], record_timestamps: true)
  user.articles.upsert({ id: 1, name: 'James' }, returning: %i[id name], unique_by: :id, record_timestamps: true)
  user.articles.upsert_all([{ id: 1, name: 'James' }], returning: %i[id name], unique_by: :id, record_timestamps: true)
  user.generate_token_for(:password_reset)
  user.values_at(:name, :age)
  user.values_at("name", :age)
  user.strict_loading!
  user.strict_loading!(false, mode: :n_plus_one_only)
  user.strict_loading?
  user.previously_persisted?
  user.read_attribute(:name)
  user.read_attribute("name")
  user.read_attribute(:name) {}

  user = User.new
  user.normalize_attribute(:email)
  User.normalize_value_for(:email, ' CRUISE-CONTROL@EXAMPLE.COM\n')
  User.with_recursive(admin_users: User.where(role: 0))

  ActiveRecord::Base.lease_connection.execute('SELECT * FROM users LIMIT 100;')

  User.unscope(:order)
  User.order(:id).unscope(:order)
  User.reorder(id: :asc)
  User.order(id: :asc).reorder(id: :desc)

  User.all.table_name

  user = User.create(name: 'James')
  user.articles
  User.create(name: 'James') { |user| user.articles }
  users = User.create([{name: 'James'}, {name: 'John'}])
  users.first.articles
  User.create([{name: 'James'}, {name: 'John'}]) { |user| user.articles }

  user = User.create!(name: 'James')
  user.articles
  User.create!(name: 'James') { |user| user.articles }
  users = User.create!([{name: 'James'}, {name: 'John'}])
  users.first.articles
  User.create!([{name: 'James'}, {name: 'John'}]) { |user| user.articles }
end

module Test
  class Tag < ApplicationRecord
    has_and_belongs_to_many :articles
    after_save_commit :reindex
    after_destroy_commit :reindex
    before_commit :reindex
    after_rollback :reindex

    def reindex
    end
  end

  class CreateTags < ActiveRecord::Migration[8.1]
    def change
      create_table :tags
    end
  end

  ActiveRecord::Type.register(:tag_list, ActiveRecord::Type::String)
  ActiveRecord::Base.lease_connection.create_table(:taggings)
  Tag.where(name: "ruby").first_or_create
  Tag.where(name: "ruby").first_or_initialize
  Tag.where(name: "ruby").create_or_find_by(name: "ruby")
  Tag.where(name: "ruby").load
  tag = Tag.new
  tag.save
  tag.save!
end

module Test
  User.model_name.human
  User.human_attribute_name(:name)
  User.inheritance_column
  User.partial_updates?
  User.strict_loading_by_default
  User.destroy(1)
  User.delete(1)
  User.where(name: "James").length
  User.all.table_name
  User.new.type_for_attribute(:name)
  User.new.column_for_attribute(:name)
  ActiveRecord.db_warnings_ignore
  ActiveRecord.application_record_class
  ActiveRecord::Base.lease_connection.open_transactions
  ActiveRecord::Encryption::Context.new.frozen_encryption?

  class CreateUsers < ActiveRecord::Migration[8.1]
    def change
      create_table :users do |t|
        # @type var t: ActiveRecord::ConnectionAdapters::TableDefinition
        t.string :name, null: false
        t.integer :age
        t.references :team
        t.timestamps
      end
    end
  end
end

module Test
  user = User.new
  user.persisted? && user.new_record? && user.destroyed? && user.previously_new_record?
  user.delete.persisted?
  user.reload.persisted?
  user.increment!(:age).decrement!(:age).persisted?
  user.toggle!(:active) && user.update_attribute(:name, "John") && user.update_column(:name, "John") && user.update_columns(name: "John")
  user.attributes.each_key(&:upcase)
  user.attribute_names.first&.upcase
  user.has_attribute?(:name)
  user.saved_changes? && user.has_changes_to_save? && user.saved_change_to_attribute?(:name)
  user.saved_changes.each_key(&:upcase)
  user.changes_to_save.each_key(&:upcase)
  user.readonly? && user.frozen?
  user.to_param&.upcase
  user.cache_key.upcase
  user.cache_version&.upcase
  user.cache_key_with_version.upcase
  user.signed_id(expires_in: 1.hour).upcase
  User.table_name.upcase
  User.column_names.first&.upcase
  User.columns_hash["name"]&.name
  User.ignored_columns.first&.upcase
  User.abstract_class? && User.sti_name.upcase
  User.readonly_attributes.first&.upcase
  User.connection_pool.db_config

  # Records built, reloaded, compared and validated
  built = User.build(name: 'James') { |user| user.articles }
  built.articles
  User.build([{ name: 'James' }, { name: 'John' }]).first&.articles
  built.reload.articles
  (built <=> User.new)&.positive?
  built.validate & built.valid?
end
