require "active_record"
require "aasm"

class Order < ActiveRecord::Base
  include AASM

  aasm column: :status, timestamps: true, no_direct_assignment: true, whiny_transitions: false, requires_lock: "FOR UPDATE", logger: Logger.new($stdout) do
    state :pending, initial: true, display: "Awaiting payment", before_enter: :audit, after_enter: [:notify, :audit]
    state :paid, :refunded
    state :canceled, exit: -> { nil }

    after_all_transitions :audit
    before_all_events { |*args| args.size }
    after_all_events :notify, :audit
    error_on_all_events :notify
    ensure_on_all_events { nil }
    before_all_transactions :audit
    after_all_transactions :notify

    event :pay, guard: :paid_ready?, after_commit: :notify, binding_event: :notify do
      before :audit
      after { |*args| args.first }
      success :notify
      error { nil }
      ensure :notify
      before_success { nil }
      before_transaction :audit
      after_commit :notify
      after_transaction :audit

      transitions from: :pending, to: :paid, guard: :paid_ready?, after: [:audit, :notify], success: :notify
      transitions from: [:paid, :refunded], to: :pending, unless: -> { false } do
        guard { true }
        after { |token| token }
        success :notify
      end
    end

    event :cancel, if: :paid_ready?, unless: :pending? do
      transitions from: [:pending, :paid], to: :canceled
    end
  end

  def audit(reason = nil)
    reason
  end

  def paid_ready?
    true
  end

  def notify
    nil
  end

  def charge(token)
    token
  end
end

# These methods use an Order instance, which needs a database connection, so they are only defined here.
def use_order(order)
  # @type var current: Symbol?
  current = order.aasm.current_state
  order.aasm.current_state = :paid
  order.aasm.current_state = "pending"
  order.aasm.human_state.upcase
  order.aasm.from_state = :pending
  order.aasm.to_state = :paid
  order.aasm.current_event = :pay
  # @type var from: Symbol?
  from = order.aasm.from_state
  # @type var to: Symbol?
  to = order.aasm.to_state
  # @type var event: Symbol?
  event = order.aasm.current_event

  order.pay
  order.pay!("tok_1")
  order.may_pay?
  order.cancel!
  order.cancel_without_validation!
  order.pending? && order.paid?

  order.aasm.fire(:pay) { nil } == true
  order.aasm.fire!("pay", "tok_2") == false
  order.aasm.may_fire_event?(:pay, "tok_3") ? 1 : 0

  order.aasm.states.map(&:name)
  order.aasm.states(permitted: true)&.map(&:to_s)
  order.aasm.states({ permitted: false }, "tok_4")&.map(&:display_name)
  order.aasm.events.map(&:name)
  order.aasm.events(state: :paid, reject: :cancel).map(&:default_display_name)
  order.aasm.events(permitted: true, reject: [:pay, :cancel]).map(&:to_s)
  order.aasm.events({ permitted: false }, "tok_5").map(&:options)
  order.aasm.permitted_transitions.each do |transition|
    transition[:event].to_s
    transition[:state].to_s
  end
end

# @type var base: AASM::Base
base = Order.aasm
base.klass.name
base.attribute_name == :status
base.attribute_name("state") == :state
base.initial_state
base.initial_state(:pending)
base.initial_state(-> { :pending })
base.states.map(&:name)
base.events.map(&:name)
base.human_event_name(:pay).upcase
base.states_for_select.map { |label, value| label + value }
base.from_states_for_state(:paid).compact.map(&:to_s)
base.from_states_for_state(:paid, transition: :pay).size

# @type var machine: AASM::StateMachine
machine = base.state_machine
machine.name
machine.states.size
machine.events[:pay]&.name
machine.initial_state
machine.config.column
machine.config.whiny_transitions
machine.config.create_scopes
machine.config.whiny_persistence
machine.config.skip_validation_on_save
machine.config.use_transactions
machine.config.requires_new_transaction
machine.config.requires_lock
machine.config.timestamps
machine.config.no_direct_assignment
machine.config.with_klass
machine.config.enum
machine.config.namespace
machine.config.logger

# @type var config: AASM::Configuration
config = AASM::Configuration.new
config.column = :status
config.whiny_transitions = false
config.create_scopes = false
config.whiny_persistence = true
config.skip_validation_on_save = true
config.use_transactions = false
config.requires_new_transaction = false
config.requires_lock = true
config.timestamps = true
config.no_direct_assignment = true
config.with_klass = AASM::Base
config.enum = :statuses
config.namespace = :billing
config.logger = Logger.new($stdout)

AASM::Configuration.hide_warnings = true
AASM::Configuration.hide_warnings
AASM::VERSION

state = Order.aasm.states.first
if state
  state.name.to_s
  state.state_machine.name
  state.options.size
  state.default_display_name.upcase
  state.to_s
  state.display_name
  state.localized_name
  state.human_name
  state.for_select.first.upcase
  state == :pending
  (state <=> :paid) == 0
end

pay_event = Order.aasm.events.first
if pay_event
  pay_event.name.to_s
  pay_event.state_machine.states
  pay_event.options.empty?
  pay_event.default_display_name
  pay_event.to_s
  pay_event == :pay
  pay_event.failed_callbacks.size
  pay_event.transitions_from_state?(:pending)
  pay_event.transitions_to_state?(:paid)
  pay_event.transitions_to_state(:paid)
  pay_event.transitions.size
end

def inspect_transitions(order, pay_event)
  pay_event.transitions_from_state(:pending).each do |transition|
    # @type var origin: Symbol?
    origin = transition.from
    transition.to.to_s
    transition.event.name
    transition.opts.empty?
    transition.options.keys
    transition.failures.size
    transition.allowed?(order, "tok_6")
    transition.from?(:pending)
    transition == transition
    origin
  end
end

# The error handling needs an Order instance, so it is only defined here.
def rescue_errors(order)
  begin
    order.pay!
  rescue AASM::InvalidTransition => e
    e.object
    e.event_name.to_s
    e.originating_state
    e.failures.size
    e.state_machine_name.to_s
    e.reasoning
    e.message
  end

  begin
    order.aasm(:missing)
  rescue AASM::UnknownStateMachineError, AASM::UndefinedEvent, AASM::UndefinedState, AASM::NoDirectAssignmentError => e
    e.message
  end
end

# A plain Ruby class and named state machines.
class Document
  include AASM

  def announce
    nil
  end

  aasm do
    state :draft, initial: true
    state :published

    event :publish do
      transitions from: :draft, to: :published, after: :announce
    end
  end

  aasm(:review, namespace: :review, column: "review_state", enum: true, create_scopes: false) do
    state :waiting, initial: true
    state :approved

    event :approve do
      transitions from: :waiting, to: :approved
    end
  end

  aasm(:work, column: :work_state) do
    state :idle, initial: true
    state :working

    event :start do
      transitions to: :working
    end
  end
end

document = Document.new
document.aasm(:review).current_state
document.aasm("work").current_state
document.publish!
document.approve_review!
document.start!
Document.aasm(:review).states.map(&:name)
Document.aasm("work").events.map(&:name)
Document.aasm.events.each do |e|
  Document.new.aasm.fire!(e.name)
end

