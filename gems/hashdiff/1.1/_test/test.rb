# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "hashdiff"

diff1 = Hashdiff.diff({a:{x:2, y:3, z:4}, b:{x:3, z:45}}, {a:{y:3}, b:{y:3, z:30}})
diff2 = Hashdiff.diff({ a: 1, b: { d: 2, a: 3 }, c: 4 }, { a: 2, b: { d: 2, a: 7 }, c: 5 }, ignore_keys: :a)
