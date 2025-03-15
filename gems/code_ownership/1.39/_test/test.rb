require "code_ownership"

class TestClass
end

CodeOwnership.for_class(TestClass)&.name
CodeOwnership.for_file('/path/to/file.rb')&.name

begin
  raise "error"
rescue StandardError => e
  CodeOwnership.for_backtrace(e.backtrace)&.name
end

CodeOwnership.for_team('My Team')
