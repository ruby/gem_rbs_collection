require "docile"

class PizzaBuilder
  def initialize
    @toppings = []
  end

  def cheese
    @toppings << :cheese
    self
  end

  def sauce(kind)
    @toppings << kind
    self
  end

  def build
    @toppings.dup
  end
end

# @type var builder: PizzaBuilder
builder = Docile.dsl_eval(PizzaBuilder.new) do
  cheese
  sauce(:tomato)
end

builder = Docile.dsl_eval(PizzaBuilder.new, :pesto) do |kind|
  sauce(kind)
end

builder = Docile.dsl_eval(PizzaBuilder.new, kind: :pesto) { cheese }

# @type var toppings: Array[Symbol]
toppings = Docile.dsl_eval_with_block_return(PizzaBuilder.new) do
  cheese
  build
end

# @type var count: Integer
count = Docile.dsl_eval_with_block_return([1, 2, 3], 4) do |n|
  push(n)
  size
end

# @type var shout: String
shout = Docile.dsl_eval_immutable("hello") do
  upcase
end

# @type var number: Integer
number = Docile.dsl_eval_immutable(1, 2) do |n|
  self + n
end

# @type var version: String
version = Docile::VERSION

# @type var list: Array[Integer]
list = Docile.dsl_eval([0]) do
  push(1)
  push(2)
end

# @type var total: Integer
total = Docile.dsl_eval_with_block_return([1, 2], step: 3) do
  size * 3
end

# @type var nothing: nil
nothing = Docile.dsl_eval_with_block_return(PizzaBuilder.new) do
  cheese
  nil
end

# @type var chained: Array[Symbol]
chained = Docile.dsl_eval_immutable(%i[b a], :c) do |extra|
  push(extra)
  sort
end
