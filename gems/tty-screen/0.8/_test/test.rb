# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "tty-screen"

height, width = TTY::Screen.size
height + width
TTY::Screen.size(verbose: true)
TTY::Screen.width.succ
TTY::Screen.columns.succ
TTY::Screen.cols.succ
TTY::Screen.height.succ
TTY::Screen.rows.succ
TTY::Screen.lines.succ
TTY::Screen::VERSION.upcase

original_env = TTY::Screen.env
TTY::Screen.env = { "LINES" => "51", "COLUMNS" => "211" }
TTY::Screen.env = ENV
TTY::Screen.env = original_env

original_output = TTY::Screen.output
TTY::Screen.output = $stdout
TTY::Screen.output = original_output
