# Pin the inferred types. Each `___error___` call is expected to fail with the
# type in the message (see steep_expectations.yml), so falling back to
# `untyped` (which accepts any method) makes the test fail.

require "csv"

# @type var opts: Hash[Symbol, untyped]
opts = { headers: true, col_sep: ";" }

# Instances
CSV.new("a,b", headers: true).___error___
CSV.new("a,b", headers: :first_row).___error___
CSV.new("a,b", headers: false).___error___
CSV.new("a,b").___error___
CSV.new("a,b", **opts).___error___
CSV.new("a,b", headers: [true, false].sample).___error___

# Rows
CSV.new("a,b", headers: true).shift.___error___
CSV.new("a,b", headers: true).read.___error___
CSV.new("a,b", headers: false).shift.___error___
CSV.new("a,b", headers: false).read.___error___

# CSV.open
CSV.open("example.csv", headers: true).___error___
CSV.open("example.csv", headers: false).___error___
CSV.open("example.csv").___error___
CSV.open("example.csv", headers: true) { |csv| csv }.___error___
CSV.open("example.csv") { |csv| csv }.___error___

# Class methods returning rows
CSV.parse("a,b", headers: true).___error___
CSV.parse("a,b").___error___
CSV.read("example.csv", headers: true).___error___
CSV.read("example.csv").___error___
CSV.foreach("example.csv", headers: true).___error___
CSV.foreach("example.csv").___error___
