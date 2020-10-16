rainbow = Rainbow("hello")

rainbow.color(:pink)
rainbow.reset
  .italic
  .bold
  .underline
  .blink
  .inverse
  .hide
  .black
  .red
  .green
  .yellow
  .blue
  .magenta
  .cyan
  .white

Rainbow.enabled
Rainbow.enabled = false
Rainbow.uncolor("a string")
