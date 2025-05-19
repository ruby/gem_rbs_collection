require "climate_control"

a = ClimateControl.modify(ABC: "abc", MY_VAR1: "var1", EDITOR: nil) do
  "#{ENV['ABC']} #{ENV['MY_VAR1']}"
end
a.upcase

xs = ClimateControl.unsafe_modify(XYZ: nil, MY_VAR2: "var2") do
  [ENV["MY_VAR2"]]
end
xs.detect { |x| x == "var1" }
