Faraday::Utils::Headers.from({}).instance_variable_get(:@names)
Faraday::Utils::Headers.allocate.instance_variable_get(:@names)
h = Faraday::Utils::Headers.new
h.initialize_names
h.initialize_copy(Faraday::Utils::Headers.new).instance_variable_get(:@names)
h[:test] = 2134
h[:test] = :df
h[:test] = nil
h[:test] = "test"

h[:test]
h["test"]

h.fetch(:test)
h.fetch("test")

h.delete(:test)
h.delete("test")

h.include?(:test) ^ true
h.include?('test') ^ true
h.has_key?(:test) ^ true
h.has_key?('test') ^ true
h.member?(:test) ^ true
h.member?('test') ^ true
h.key?(:test) ^ true
h.key?('test') ^ true

h.merge!({ ok: 2134, foo: "m" }).parse("Authorization: Bearer token")

h.update({ ok: 2134, foo: "m" }).parse("Authorization: Bearer token")

h.merge({ ok: 2134, foo: "m" }).parse("Authorization: Bearer token")

h.replace({ ok: 2134, foo: "m" }).parse("Authorization: Bearer token")

h.to_hash.parse("Authorization: Bearer token")

h.parse("Authorization: Bearer token")
h.parse(nil)

h.send(:names)
h.send(:add_parsed, 'key', 'value')
h.send(:add_parsed, :key, "123")
