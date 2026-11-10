class NilableJob
  include Sidekiq::Job
end

# push returns nil when client middleware halts the job
jid = Sidekiq::Client.new.push('class' => NilableJob, 'args' => [1, 2, 3])
jid&.upcase
NilableJob.perform_async(1)&.upcase
NilableJob.perform_in(60, 1)&.upcase
