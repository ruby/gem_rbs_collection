# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "importmap-rails"

module ImportmapTest
  def self.ensure_map(app)
    app.importmap ||= Importmap::Map.new
  end

  def self.drawn?(app)
    !app.importmap.nil?
  end
end
