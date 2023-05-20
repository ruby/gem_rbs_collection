require "moneta"

# @type var key_transformer: ::Moneta::_KeyValueTransformer
key_transformer = _ = Moneta.new(:File, dir: "data")
key_transformer.key?("key")
key_transformer.each_key { |key| key }
key_transformer.increment("key", 1, { expires: false })
key_transformer.load("key")
key_transformer.store("key", 34, expires: 3)
key_transformer.delete("key", raw: true)
key_transformer.create("key", "val1", expires: false)
key_transformer.values_at("key1", "key2")
key_transformer.fetch_values("key1", "key2", expires: false)
key_transformer.slice("key1", "key2", expires: false)
key_transformer.merge!([["key1", 12], ["key2", :ok]], expires: false)

# @type var value_transformer: ::Moneta::_ValueTransformer
value_transformer = _ = Moneta.new(:File, dir: "data")
value_transformer.load("key")
value_transformer.store("key", 34, expires: 3)
value_transformer.delete("key", raw: true)
value_transformer.create("key", "val1", expires: false)
value_transformer.values_at("key1", "key2")
value_transformer.fetch_values("key1", "key2", expires: false)
value_transformer.slice("key1", "key2", expires: false)
value_transformer.merge!({ key1: 1, key2: true }, expires: false)

m = Moneta.build { use :Transformer, key: [:json]; adapter :Memory }
m.load("key")
m.store("key", 34, expires: 3)
m.delete("key", raw: true)
m.create("key", "val1", expires: false)
m.values_at("key1", "key2")
m.fetch_values("key1", "key2", expires: false)
m.slice("key1", "key2", expires: false)
m.merge!({ key1: 1, key2: true }, expires: false)
