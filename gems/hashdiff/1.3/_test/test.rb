require "hashdiff"

# @type var version: String
version = Hashdiff::VERSION

# @type var diff1: Array[Hashdiff::change[String]]
diff1 = Hashdiff.diff({a:{x:2, y:3, z:4}, b:{x:3, z:45}}, {a:{y:3}, b:{y:3, z:30}})
# @type var diff2: Array[Array[untyped]]
diff2 = Hashdiff.diff({ a: 1, b: { d: 2, a: 3 }, c: 4 }, { a: 2, b: { d: 2, a: 7 }, c: 5 }, ignore_keys: :a)

# Arrays and values
# @type var diff3: Array[Hashdiff::change[String]]
diff3 = Hashdiff.diff([1, 2, 3], [1, 3, 4], use_lcs: false)
Hashdiff.diff(1, 2.0, strict: false, numeric_tolerance: 1)
Hashdiff.diff(nil, nil)

# Options
Hashdiff.diff({ a: { b: 1 } }, { a: { b: 2 } }, delimiter: "/", similarity: 0.5, indifferent: true,
                                                strip: true, case_insensitive: true, preserve_key_order: true,
                                                ignore_keys: %i[c d])

# Custom comparison: a String path by default
Hashdiff.diff({ a: "car" }, { a: "bus" }) do |path, _obj1, _obj2|
  path.split(".").size == 1
end
# @type var comparison: ^(String, untyped, untyped) -> boolish
comparison = ->(path, _obj1, _obj2) { path.end_with?("a") ? true : nil }
Hashdiff.diff({ a: "car" }, { a: "bus" }, comparison: comparison)

# array_path: true gives Array paths
# @type var diff4: Array[Hashdiff::change[Array[untyped]]]
diff4 = Hashdiff.diff({ x: [0, 1] }, { x: [0, 2] }, array_path: true) do |path, _obj1, _obj2|
  path.size > 1 ? nil : false
end

# An options Hash
options = { delimiter: "/", array_path: false }
Hashdiff.diff({ a: 1 }, { a: 2 }, options) do |path, _obj1, _obj2|
  path.is_a?(String)
end

# @type var best: Array[Hashdiff::change[String]]
best = Hashdiff.best_diff({ x: [{ a: 1, c: 3 }, { y: 3 }] }, { x: [{ a: 1, b: 2 }] })
Hashdiff.best_diff([{ a: 1 }], [{ a: 2 }], array_path: true) { |path, _a, _b| path.empty? ? nil : nil }
Hashdiff.best_diff({ a: 1 }, { a: 2 }, delimiter: "\t") { |path, _a, _b| path.empty? ? nil : nil }
Hashdiff.best_diff({ a: 1 }, { a: 2 }, options)

# Patch and unpatch return the object they change
a = { "a" => 3 }
b = { "a" => { "a1" => 1, "a2" => 2 } }
# @type var patched: Hash[String, untyped]
patched = Hashdiff.patch!(a, Hashdiff.diff(a, b))
# @type var unpatched: Hash[String, untyped]
unpatched = Hashdiff.unpatch!(patched, Hashdiff.diff(a, b, delimiter: "/"), delimiter: "/")

list = [1, { "a" => 1 }]
# @type var patched_list: Array[Integer | Hash[String, Integer]]
patched_list = Hashdiff.patch!(list, [["+", "[0]", 0]])
# @type var unpatched_list: Array[Integer | Hash[String, Integer]]
unpatched_list = Hashdiff.unpatch!(list, [["+", [0], 0]], { delimiter: "." })

# A change is a tuple tagged "+", "-" or "~"
diff1.each do |change|
  # @type var op: "+" | "-" | "~"
  op = change[0]
  # @type var change_path: String
  change_path = change[1]
  puts "#{op}#{change_path}"
end
Hashdiff.patch!({ a: 1 }, [["~", "a", 1, 2]])
