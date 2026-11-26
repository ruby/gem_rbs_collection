# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "database_cleaner/core"

class MyStrategy < DatabaseCleaner::Strategy
  def clean
    nil
  end
end

DatabaseCleaner.allow_production = true
DatabaseCleaner.allow_remote_database_url = true
DatabaseCleaner.url_allowlist = ["postgres://postgres@localhost", %r{\Apostgres://}, proc { |_url| true }]
DatabaseCleaner.url_whitelist = nil

cleaner = DatabaseCleaner[:active_record, db: :two]
cleaner.strategy = MyStrategy.new
cleaner.strategy.clean
cleaner.db = :three
cleaner.orm.to_s
(cleaner <=> DatabaseCleaner[:active_record])&.positive?

DatabaseCleaner.strategy = :transaction
DatabaseCleaner.strategy = [:truncation, { only: %w[widgets dogs] }]
DatabaseCleaner.strategy = MyStrategy.new
DatabaseCleaner.strategy.each_value(&:start)
DatabaseCleaner.clean_with(:truncation)
DatabaseCleaner.clean_with(:truncation, except: %w[widgets])
DatabaseCleaner.start.first&.orm
DatabaseCleaner.clean.size
count = DatabaseCleaner.cleaning { 1 + 1 }
count + 1

DatabaseCleaner::Cleaner.available_strategies(DatabaseCleaner).map(&:to_s)
DatabaseCleaner.cleaners = DatabaseCleaner::Cleaners.new
DatabaseCleaner.cleaners.values.map(&:db)

begin
  DatabaseCleaner::Safeguard.new.run
rescue DatabaseCleaner::Safeguard::Error => e
  e.message
end

DatabaseCleaner::NullStrategy.new.cleaning { "done" }.upcase
