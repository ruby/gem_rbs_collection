require "matrix"

# Constructors infer the element type.
# @type var m: Matrix[Integer]
m = Matrix[[1, 2], [3, 4]]
# @type var f: Matrix[Float]
f = Matrix.rows([[1.0, 2.0], [3.0, 4.0]])
# @type var c: Matrix[Integer]
c = Matrix.columns([[1, 3], [2, 4]])
# @type var built: Matrix[String]
built = Matrix.build(2, 3) { |row, col| "#{row},#{col}" }
# @type var build_enum: Enumerator[[Integer, Integer], Matrix[untyped]]
build_enum = Matrix.build(2)
# @type var diagonal: Matrix[Float | Integer]
diagonal = Matrix.diagonal(1.5, 2.5)
# @type var identity: Matrix[Integer]
identity = Matrix.identity(2)
# @type var zero: Matrix[Integer]
zero = Matrix.zero(2, 3)
# @type var row_matrix: Matrix[Integer]
row_matrix = Matrix.row_vector(Vector[1, 2])
# @type var column_matrix: Matrix[Integer]
column_matrix = Matrix.column_vector([1, 2])
# @type var stacked: Matrix[Integer]
stacked = Matrix.vstack(m, identity)
# @type var combined: Matrix[Integer]
combined = Matrix.combine(m, identity) { |elements| elements.sum }
puts built, build_enum, diagonal, zero, row_matrix, column_matrix, stacked, combined, Matrix.unit(3), Matrix.empty(0, 2)

# Taking elements out keeps T.
# @type var element: Integer
element = m[0, 1]
# @type var row: Vector[Integer]
row = m.row(0)
# @type var column: Vector[Integer]
column = m.column(1)
# @type var rows: Array[Array[Integer]]
rows = m.to_a
# @type var row_vectors: Array[Vector[Integer]]
row_vectors = m.row_vectors
m.each { |e| puts e.succ }
m.each(:diagonal) { |e| puts e.succ }
# @type var strict_lower: Array[Integer]
strict_lower = m.each(:strict_lower).to_a
m.each_with_index { |e, i, j| puts e.succ + i + j }
# @type var position: [Integer, Integer]?
position = m.index(4)
# @type var even_position: [Integer, Integer]?
even_position = m.index(:upper, &:even?)
# @type var sum: Integer
sum = m.sum
puts element, row, column, rows, row_vectors, strict_lower, position, even_position, sum, m.minor(0..1, 0..0), m.first_minor(0, 0)

# Element type changes through blocks.
# @type var strings: Matrix[String]
strings = m.map(&:to_s)
# @type var partially_mapped: Matrix[Integer | String]
partially_mapped = m.collect(:diagonal, &:to_s)
m.dup.collect!(:off_diagonal) { |e| e * 10 }
puts strings, partially_mapped

# Same element types keep T.
# The results are not annotated, so calling a method on their elements
# would be reported as an untyped call if T were lost.
puts((m * m)[0, 0].succ)
puts((m * 2)[0, 0].succ)
puts((m * Vector[1, 1])[0].succ)
puts((m + identity)[0, 0].succ)
puts((column_matrix - Vector[1, 1])[0, 0].succ)
puts((f - f)[0, 0].floor)
puts((f / 2.0)[0, 0].floor)
puts((m / 2)[0, 0].succ)
puts((-m)[0, 0].succ)
puts(m.transpose[0, 0].succ)
puts(m.trace.succ)
puts(m.conj[0, 0].succ)
puts(m.adjoint[0, 0].succ)
puts(m.hadamard_product(m)[0, 0].succ)
puts(m.rotate_entries(:half_turn)[0, 0].succ)
puts(m.hstack(identity)[0, 0].succ)
puts(m.vstack(identity)[0, 0].succ)

# Other operations fall back to untyped.
# @type var promoted: Matrix[untyped]
promoted = m * 1.5
# @type var inverse: Matrix[untyped]
inverse = m.inverse
# @type var divided: Matrix[untyped]
divided = m / m
# @type var power: Matrix[untyped]
power = m**2
# @type var abs: Matrix[untyped]
abs = m.abs
# @type var rounded: Matrix[untyped]
rounded = f.round(1)
# @type var mixed: Matrix[untyped]
mixed = m + f
puts promoted, inverse, divided, power, abs, rounded, mixed

# The determinant is T or Integer: a singular matrix of size 5 or more
# returns Integer 0 even with Float elements.
puts(m.determinant.succ)
puts(m.det.succ)
puts(m.cofactor(0, 0).succ)
puts(m.adjugate[0, 0].succ)
puts(m.laplace_expansion(row: 0).succ)
puts(f.laplace_expansion(column: 0).floor)
puts(f.det.abs < 1e-9)
puts(f.cofactor(0, 1) < 0)
puts(f.adjugate[0, 0].abs)
puts(Matrix.build(5) { 1.0 }.det.zero?)

# Predicates and properties.
# @type var flags: Array[bool]
flags = [m.square?, m.symmetric?, m.regular?, m.empty?, m.upper_triangular?, m.zero?]
# @type var rank: Integer
rank = m.rank
puts flags, rank, m.row_count, m.column_size

m[0, 0] = 10
m[0..1, 1] = Vector[5, 6]

# Decompositions.
l, u, p = m.lup
# @type var solved: Vector[untyped]
solved = m.lup.solve([1, 2])
# @type var pivots: Array[Integer]
pivots = m.lup.pivots
# @type var eigenvalues: Array[Float | Complex]
eigenvalues = m.eigensystem.eigenvalues
v, d, v_inv = m.eigen
puts l, u, p, solved, pivots, eigenvalues, v, d, v_inv

begin
  Matrix[[1, 2]].inverse
rescue Matrix::ErrDimensionMismatch => e
  puts e.message
end

# Vector
# @type var vec: Vector[Integer]
vec = Vector[1, 2, 3]
# @type var fvec: Vector[Float]
fvec = Vector.elements([1.0, 2.0, 3.0])
# @type var vec_element: Integer
vec_element = vec[0]
# @type var vec_slice: Array[Integer]?
vec_slice = vec[0..1]
# @type var vec_sum: Vector[Integer]
vec_sum = vec + Vector.zero(3)
# @type var vec_scaled: Vector[Integer]
vec_scaled = vec * 2
# @type var vec_promoted: Vector[untyped]
vec_promoted = vec * 0.5
# @type var dot: Integer
dot = vec.dot(Vector.basis(size: 3, index: 0))
# @type var fdot: untyped
fdot = vec.inner_product(fvec)
# @type var cross: Vector[Integer]
cross = vec.cross(Vector[0, 1, 0])
# @type var norm: Float
norm = vec.norm
# @type var normalized: Vector[untyped]
normalized = vec.normalize
# @type var angle: Float | Integer
angle = vec.angle_with(fvec)
# @type var pairs: Vector[String]
pairs = vec.map2(fvec) { |a, b| "#{a}:#{b}" }
# @type var collected: Array[Float]
collected = vec.collect2([1.0, 2.0, 3.0]) { |a, b| a * b }
# @type var covector: Matrix[Integer]
covector = vec.covector
# @type var vec_to_m: Matrix[Integer]
vec_to_m = vec.to_matrix
# @type var vm: Matrix[Integer]
vm = vec * covector
puts((vec + vec)[0].succ)
puts((vec - vec)[0].succ)
puts((vec * 2)[0].succ)
puts((vec / 2)[0].succ)
puts((-vec)[0].succ)
puts(vec.dot(vec).succ)
puts(vec.cross(vec)[0].succ)
puts((vec * covector)[0, 0].succ)
puts(vec.to_a.first&.succ)
vec.each { |e| puts e.succ }
vec.each2(fvec) { |a, b| puts a.succ, b.floor }
puts vec_element, vec_slice, vec_sum, vec_scaled, vec_promoted, dot, fdot, cross, norm, normalized, angle, pairs, collected, vec_to_m, vm
puts Vector.independent?(vec, Vector[0, 1, 0]), vec.zero?, vec.size, vec.map(&:to_s), vec.to_a

begin
  Vector[0, 0].normalize
rescue Vector::ZeroVectorError => e
  puts e.message
end
