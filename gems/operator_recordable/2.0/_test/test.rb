# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "operator_recordable"
require "active_record"

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include OperatorRecordable::Extension
end

class Post < ApplicationRecord
  record_operator_on :create, :update, :destroy
end

class Operator < ApplicationRecord
end

OperatorRecordable.operator = Operator.new
