require "ruby-progressbar"
require "ruby-progressbar/outputs/null"
require "stringio"

output = StringIO.new

bar = ProgressBar.create(
  title: "Items",
  total: 10,
  starting_at: 0,
  format: "%t: |%B| %p%%",
  length: 40,
  output: output,
  throttle_rate: 0.1,
  progress_mark: "#",
  remainder_mark: ".",
  unknown_progress_animation_steps: ["==>", "-==", ">-="],
  projector: { type: "smoothed", strength: 0.2 },
  rate_scale: ->(rate) { rate * 60 },
  autostart: true,
  autofinish: true
)

bar.increment
bar.decrement
bar.progress += 3
bar.total = 20
bar.title = "Renamed"
bar.progress_mark = "="
bar.remainder_mark = " "
bar.format = "%a %e %P%"
bar.format("%t %c/%C")
bar.log("message")
bar.refresh(force: true)
bar.clear
bar.pause
bar.resume
bar.stop
bar.reset
bar.start(at: 5)

progress = bar.progress
total = bar.total
title = bar.title
string = bar.to_s
string = bar.to_s("%t")
inspection = bar.inspect
hash = bar.to_h
percentage = hash["percentage"]
throttle_rate = hash["throttle_rate"]

started = bar.started?
stopped = bar.stopped?
paused = bar.paused?
finished = bar.finished?

bar.finish

unknown = ProgressBar.create(total: nil, output: ProgressBar::Outputs::Null)
unknown.increment
unknown.total = 3
unknown.progress = 3

ProgressBar.create.finish

begin
  ProgressBar.create(total: 1, output: output).progress = 2
rescue ProgressBar::InvalidProgressError => error
  error.message
end

ProgressBar.create(output: output, starting_at: nil, length: nil).to_h["output_stream"]
ProgressBar::Refinements::Enumerator::ARITY_ERROR_MESSAGE.size
ProgressBar::Outputs::Tty::DEFAULT_FORMAT_STRING.size
