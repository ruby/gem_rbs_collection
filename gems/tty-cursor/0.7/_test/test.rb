# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "stringio"
require "tty-cursor"

cursor = TTY::Cursor

print cursor.show + cursor.hide
cursor.invisible { 1 + 1 }
result = cursor.invisible($stderr) { "done" }
result.upcase
cursor.invisible(StringIO.new) { nil }

print cursor.save, cursor.restore, cursor.current
print cursor.move_to, cursor.move_to(2, 3), cursor.move(-1, 2)
print cursor.up, cursor.up(2), cursor.down(nil), cursor.backward(3), cursor.forward
print cursor.column(4), cursor.row, cursor.next_line, cursor.prev_line
print cursor.clear_char, cursor.clear_char(5), cursor.clear_line
print cursor.clear_line_before, cursor.clear_line_after
print cursor.clear_lines(3), cursor.clear_lines(2, :down)
print cursor.clear_screen_down, cursor.clear_screen_up, cursor.clear_screen
print cursor.scroll_up, cursor.scroll_down
print TTY::Cursor::VERSION, TTY::Cursor::CSI

class Screen
  include TTY::Cursor

  def redraw
    cursor_up(2) + cursor_down + cursor_backward(1) + cursor_forward(nil) +
      clear_rows(2, :up) + move_to(0, 0) + clear_line
  end
end

Screen.new.redraw.length
