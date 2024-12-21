user = User.new(secret: 'dummy', key: 'dummy', token: 'dummy', phrase: 'dummy')
user.articles.insert({ id: 1, name: 'James' }, returning: %i[id name], unique_by: :id, record_timestamps: true)
user.articles.insert!({ id: 1, name: 'James' }, returning: %i[id name], record_timestamps: true)
user.articles.insert_all([{ id: 1, name: 'James' }], returning: %i[id name], unique_by: :id, record_timestamps: true)
user.articles.insert_all!([{ id: 1, name: 'James' }], returning: %i[id name], record_timestamps: true)
user.articles.upsert({ id: 1, name: 'James' }, returning: %i[id name], unique_by: :id, record_timestamps: true)
user.articles.upsert_all([{ id: 1, name: 'James' }], returning: %i[id name], unique_by: :id, record_timestamps: true)
user.values_at(:name, :age)
user.values_at("name", :age)
User.strict_loading
User.strict_loading(false)
user.strict_loading!
user.strict_loading?
