registry = Faraday::AdapterRegistry.new
registry.get('Faraday::Connection')
registry.get(:Faraday)
registry.set(:Wind)
registry.set(:Wave, nil)
registry.set(:Sea, :new_name)
registry.set(:Mountain, "another")
registry.set(:Star, 123)
