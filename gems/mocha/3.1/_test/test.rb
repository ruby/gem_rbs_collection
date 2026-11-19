# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "mocha"

class Sheep
  def initialize(name)
    @name = name
  end

  def chew(grass)
    "#{@name} chews #{grass}"
  end
end

class Stubbable
  include Mocha::ObjectMethods
end

class MochaAPITest
  include Mocha::API

  def test_mocks
    motor = mock("motor", start: true, stop: true)
    motor.expects(:start).with(anything, instance_of(String)).returns(true).once
    motor.expects(:stop).with { |*args| args.empty? }.raises(ArgumentError, "stopped").never
    motor.stubs(speed: 10)
    motor.stubs("brake").yields(1).then.returns(nil).at_least_once
    motor.expects(:turn).times(2..3).in_sequence(sequence("turns"))
    motor.expects(:honk).twice.at_most(4).throws(:done)
    motor.unstub(:start, :stop)

    mock(start: true).expects(:start).at_least(1)
    mock(:named).stubs(:run).thrice.with_no_block_given
    stub.stubs(:run).multiple_yields([1], [2]).at_most_once
    stub_everything("everything", run: true).expects(:run).with_block_given

    power = states("power").starts_as("off")
    radio = stub("radio")
    radio.expects(:switch_on).then(power.is("on"))
    radio.expects(:select_channel).with(has_entry(name: "BBC")).when(power.is("on"))
    radio.expects(:switch_off).when(power.is_not("off"))

    sequence("breakfast") do
      radio.expects(:crack).with(has_entry("key", 1) & has_key(:key))
      radio.expects(:fry).with(any_of(1, 2) | Not(equals(3)))
    end

    radio.expects(:serve).with(
      all_of(kind_of(Integer), is_a(Comparable)),
      has_entries(a: 1),
      has_keys(:a, :b),
      has_value(1),
      includes(1, 2),
      regexp_matches(/\d+/),
      responds_with(:upcase, "FOO"),
      responds_with(upcase: "FOO"),
      yaml_equivalent([1]),
      equivalent_uri("https://example.com/?a=1"),
      optionally(1)
    )
    radio.expects(:anything).with(any_parameters)

    sheep = mock("sheep").responds_like_instance_of(Sheep)
    sheep.chew("grass").upcase
    sheep.expects(:chew).returns("chewed")

    like = mock("like").responds_like(Sheep.new("dolly"))
    like.chew("grass").upcase
    like.stubs(:chew)

    stubbable = Stubbable.new
    stubbable.expects(:a).returns(1)
    stubbable.stubs(b: 2)
    stubbable.unstub(:a, :b)
  end
end
