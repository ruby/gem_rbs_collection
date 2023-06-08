require "simplecov"

SimpleCov.start

SimpleCov.start 'rails'

SimpleCov.start do
  add_filter 'test'
end

SimpleCov.start 'rails' do
  add_filter 'test'
end

SimpleCov.start do
  enable_coverage :line
  enable_coverage :branch

  enable_coverage_for_eval

  primary_coverage :line
  primary_coverage :branch
end

SimpleCov.start do
  add_filter 'test'
  add_filter %r{test}

  add_filter do |source_file|
    source_file.lines.count < 5
  end
end

class LineFilter < SimpleCov::Filter
  def matches?(source_file)
    source_file.lines.count < filter_argument
  end
end
SimpleCov.add_filter LineFilter.new(5)

SimpleCov.start do
  proc = ->(source_file) { false }
  add_filter ["string", /regex/, proc, LineFilter.new(5)]
end

SimpleCov.start :rails do
  filters.clear
  add_filter do |src|
    !(src.filename =~ /^#{SimpleCov.root}/) unless src.filename =~ /my_engine/
  end
end

SimpleCov.start do
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Long files" do |src_file|
    src_file.lines.count > 100
  end
  add_group "Multiple Files", ["app/models", "app/controllers"]
  add_group "Short files", LineFilter.new(5)
end

SimpleCov.command_name 'test:units'

SimpleCov.collate Dir["simplecov-resultset-*/.resultset.json"]
