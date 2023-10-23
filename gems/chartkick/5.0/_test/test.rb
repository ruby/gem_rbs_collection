# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "chartkick"

module Example
  include ChartKick::Helper

  def example
    data = [
      ["Washington", "1789-04-29", "1797-03-03"],
      ["Adams", "1797-03-03", "1801-03-03"],
      ["Jefferson", "1801-03-03", "1809-03-03"]
    ]

    line_chart data

    pie_chart data

    column_chart data

    bar_chart data

    area_chart data

    scatter_chart data

    geo_chart data

    timeline [
      ["Washington", "1789-04-29", "1797-03-03"],
      ["Adams", "1797-03-03", "1801-03-03"],
      ["Jefferson", "1801-03-03", "1809-03-03"]
    ]

    line_chart [
      {name: "Workout", data: {"2021-01-01" => 3, "2021-01-02" => 4}},
      {name: "Call parents", data: {"2021-01-01" => 5, "2021-01-02" => 3}}
    ]

    line_chart data
  end
end
