# RBS for aasm gem

The directory that defines the RBS files for the [aasm](https://github.com/aasm/aasm) gem.

## Usage

`include AASM` defines `aasm do ... end` and the instance-side `aasm` in the class,
but RBS cannot extend a module dynamically.
Add `extend AASM::ClassMethods` to the RBS of the class that includes AASM.

```ruby
# order.rb
class Order < ApplicationRecord
  include AASM

  aasm column: :status do
    state :pending, initial: true
    state :paid

    event :pay do
      transitions from: :pending, to: :paid
    end
  end
end
```

```rbs
# order.rbs
class Order < ApplicationRecord
  include AASM
  extend AASM::ClassMethods
end
```

## Methods defined by the DSL

The `<event>`, `<event>!`, `may_<event>?` and `<state>?` methods are defined for each state and event
of the model, so this RBS cannot know their names.
Write them in the RBS of the model.

```rbs
# order.rbs
class Order < ApplicationRecord
  include AASM
  extend AASM::ClassMethods

  def pay: () -> bool
  def pay!: () -> bool
  def may_pay?: () -> bool
  def pending?: () -> bool
  def paid?: () -> bool
end
```
