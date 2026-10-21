require "solid_queue"

class BatchIdTestJob < ActiveJob::Base
  include ActiveJob::BatchId
end

BatchIdTestJob.new.serialize.fetch("job_class")
