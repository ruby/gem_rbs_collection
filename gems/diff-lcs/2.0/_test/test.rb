require "diff/lcs"
require "diff/lcs/hunk"
require "diff/lcs/string"
require "diff/lcs/array"

seq1 = %w[a b c e h j l m n p]
seq2 = %w[b c d e f j k l m r s t]
seq3 = "hoge"
seq4 = "hoga"

# @type var lcs: Array[String]
lcs = Diff::LCS.lcs(seq1, seq2)
lcs = Diff::LCS.lcs(seq3, seq4)
# @type var upcased: Array[String]
upcased = Diff::LCS.lcs(seq1, seq2) { |element| element.upcase }

# @type var diffs: Array[Array[Diff::LCS::Change[String]]]
diffs = Diff::LCS.diff(seq1, seq2)
diffs = Diff::LCS.diff(seq3, seq4)
# @type var diff_arrays: Array[Array[[String, Integer, String]]]
diff_arrays = Diff::LCS.diff(seq1, seq2) { |change| change.to_a }
# @type var context_diffs: Array[Array[Diff::LCS::ContextChange[untyped]]]
context_diffs = Diff::LCS.diff(seq1, seq2, Diff::LCS::ContextDiffCallbacks)

# @type var sdiff: Array[Diff::LCS::ContextChange[String]]
sdiff = Diff::LCS.sdiff(seq1, seq2)
sdiff = Diff::LCS.sdiff(seq3, seq4)
# @type var sdiff_callbacks: Array[Diff::LCS::ContextChange[untyped]]
sdiff_callbacks = Diff::LCS.sdiff(seq1, seq2, Diff::LCS::SDiffCallbacks.new)

# @type var patched: Array[String]
patched = Diff::LCS.patch!(seq1, diffs)
patched = Diff::LCS.unpatch!(seq2, diffs)
patched = Diff::LCS.patch(seq1, sdiff, :patch)
# @type var patched_string: String
patched_string = Diff::LCS.patch(seq3, Diff::LCS.diff(seq3, seq4))

# @type var traversed: nil
traversed = Diff::LCS.traverse_sequences(seq1, seq2, Diff::LCS::SequenceCallbacks)
traversed = Diff::LCS.traverse_balanced(seq1, seq2) { |event| event }

callbacks = Diff::LCS::DiffCallbacks.new
Diff::LCS.traverse_sequences(seq1, seq2, callbacks)
callbacks.finish
# @type var collected: Array[Array[Diff::LCS::Change[untyped]]]
collected = callbacks.diffs

change = diffs.first.first
# @type var action: Diff::LCS::Change::action
action = change.action
# @type var position: Integer
position = change.position
# @type var element: String
element = change.element
# @type var adding: bool
adding = change.adding?
# @type var compared: Integer?
compared = change <=> Diff::LCS::Change.new("+", 0, "a")
# @type var from_a: Diff::LCS::Change[String]
from_a = Diff::LCS::Change.from_a(["+", 0, "a"])

context_change = sdiff.first
# @type var old_element: String?
old_element = context_change.old_element
# @type var new_position: Integer
new_position = context_change.new_position
# @type var simplified: Diff::LCS::ContextChange[String]
simplified = Diff::LCS::ContextChange.simplify(context_change)

hunk = Diff::LCS::Hunk.new(seq1, seq2, diffs.first, 3, 0)
# @type var unified: String
unified = hunk.diff(:unified)
# @type var overlaps: bool?
overlaps = hunk.overlaps?(nil)
# @type var length_difference: Integer
length_difference = hunk.file_length_difference
# @type var blocks: Array[Diff::LCS::Block]
blocks = hunk.blocks
# @type var op: String
op = blocks.first.op

# @type var string_lcs: Array[untyped]
string_lcs = seq3.lcs(seq4)
# @type var string_patched: String
string_patched = seq3.patch(seq3.diff(seq4))
# @type var array_patched: Array[String]
array_patched = seq1.patch_me(seq1.diff(seq2))

# @type var lines: Array[String] | String
lines = [seq1, seq3].sample || seq3
# @type var any_diffs: Array[Array[Diff::LCS::Change[untyped]]]
any_diffs = Diff::LCS.diff(lines, seq4)
# @type var any_patched: Array[untyped] | String
any_patched = Diff::LCS.patch!(lines, any_diffs)

context_callbacks = Diff::LCS::ContextDiffCallbacks.new { |cbo| Diff::LCS.traverse_balanced(seq1, seq2, cbo) }
# @type var context_hunks: Array[Array[Diff::LCS::ContextChange[untyped]]]
context_hunks = context_callbacks.diffs
