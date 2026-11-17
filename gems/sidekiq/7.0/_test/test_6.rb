class NilableJob
  include Sidekiq::Job
end

# push returns the job ID, or nil when client middleware halts the job
jid = Sidekiq::Client.new.push('class' => NilableJob, 'args' => [1, 2, 3])
jid&.upcase
Sidekiq::Client.push('class' => NilableJob, 'args' => [1])&.upcase
NilableJob.client_push('class' => NilableJob, 'args' => [1])&.upcase
