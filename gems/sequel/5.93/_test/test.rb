require "sequel"

# Basic database connection
db = Sequel.sqlite
db = Sequel.sqlite(':memory:')
db = Sequel.connect('sqlite::memory:')

# Dataset creation and basic operations
users = db[:users]
users = db.from(:users)

# Query building
filtered = users.where(active: true)
filtered = users.where(id: 1)
filtered = users.filter(name: 'John')
filtered = users.exclude(deleted: true)

selected = users.select(:id, :name)
joined = users.join(:posts, user_id: :id)
joined = users.left_join(:posts, user_id: :id)

ordered = users.order(:created_at)
limited = users.limit(10)
limited = users.limit(10, 20)
offset = users.offset(20)
distinct = users.select(:name).distinct

# Data retrieval
all_users = users.all
first_user = users.first
count = users.count
empty = users.empty?

users.each do |user|
  user[:name]
  user[:email]
end

# Data manipulation
user_id = users.insert(name: 'Bob', email: 'bob@example.com')
affected = users.where(id: 1).update(name: 'Updated')
deleted = users.where(id: 1).delete

# SQL generation
sql = users.where(active: true).sql

# Transactions
db.transaction do
  users.insert(name: 'Transaction Test', email: 'trans@example.com')
end

in_transaction = db.in_transaction?

# Execute raw SQL
db.run("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT)")
result = db.execute("SELECT * FROM users")

# Schema operations
if !db.table_exists?(:users)
  db.create_table :users do
    # Block content is untyped - DSL is too complex for RBS
  end
end

tables = db.tables
db.drop_table(:users) if db.table_exists?(:users)

# Sequel functions
expr = Sequel.expr(name: 'John')
literal = Sequel.lit("name = ?", 'John')
aliased = Sequel.as(:name, :user_name)
func = Sequel.function(:count, :*)
casted = Sequel.cast(:age, :integer)

# Model definition and usage
class User < Sequel::Model
  set_dataset db[:users]
  plugin :validation_helpers
end

# Model class methods
User.dataset
User.db
User.db = db
User.table_name

# CRUD operations
user = User.new(name: 'Test', email: 'test@example.com')
user.save

user = User.create(name: 'Created', email: 'created@example.com')
found = User[1]
found = User[name: 'Test']
found = User.find(email: 'test@example.com')
found_or_created = User.find_or_create(email: 'new@example.com')

# Query methods
all_users = User.all
first_user = User.first
last_user = User.last
filtered_users = User.where(active: true)
user_count = User.count

# Instance methods
user.values
user[:name]
user[:name] = 'Updated'
user.update(name: 'New Name')
user.delete
user.refresh

# State checking
user.new?
user.modified?
user.pk

# Validation
user.valid?
user.errors

# Error handling
begin
  User.create(name: nil)
rescue Sequel::ValidationFailed => e
  e.message
  e.errors
end

begin
  db.execute("INVALID SQL")
rescue Sequel::DatabaseError => e
  e.message
end