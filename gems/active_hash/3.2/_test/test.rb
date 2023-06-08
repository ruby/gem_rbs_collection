# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "active_hash"

class Colour < ActiveHash::Base
  include ActiveHash::Enum

  enum_accessor :name

  self.data = [
      { id: 1, name: "red", code: "#ff0000" },
      { id: 2, name: "green", code: "#00ff00" },
      { id: 3, name: "blue", code: "#0000ff" }
  ]
end
