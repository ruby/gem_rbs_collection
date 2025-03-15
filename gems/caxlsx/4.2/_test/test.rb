require "caxlsx"

package = Axlsx::Package.new
package.to_stream
io = package.to_stream(true)
io.read if io

workbook = package.workbook
workbook.add_worksheet(
  name: 'worksheet name',
)
