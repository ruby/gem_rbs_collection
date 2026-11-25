require "knapsack"

Knapsack::VERSION.upcase
Knapsack.root.upcase
Knapsack::Config::Env.report_path&.upcase
Knapsack::Config::Env.test_file_pattern&.upcase
Knapsack::Config::Env.test_dir&.upcase
Knapsack::Config::Env.ci_node_total.to_i
Knapsack::Config::Env.ci_node_index.to_i
Knapsack::Config::Env.log_level + 1

Knapsack.tracker.config({ enable_time_offset_warning: true, time_offset_in_seconds: 30 })
Knapsack.report.config({ test_file_pattern: "spec/**{,/*/**}/*_spec.rb", report_path: "knapsack_rspec_report.json" })
Knapsack.report.report_path.upcase
Knapsack.report.test_file_pattern.upcase

logger = Knapsack::Logger.new
logger.level = Knapsack::Logger::INFO
logger.level&.succ
logger.info("hello")
logger.log(Knapsack::Logger::WARN, "warning")
Knapsack.logger = logger
Knapsack.logger = Knapsack::Logger.new
Knapsack.logger.info("hello")
Knapsack.logger = nil

tracker = Knapsack.tracker
tracker.test_path = "spec/a_spec.rb"
tracker.start_timer.floor
tracker.stop_timer.floor
tracker.test_path&.upcase
tracker.global_time.floor
tracker.test_files_with_time.each { |path, time| path.upcase + time.floor.to_s }
tracker.reset!

report = { "spec/a_spec.rb" => 1.5, "spec/b_spec.rb" => 2 }
distributor = Knapsack::Distributors::ReportDistributor.new(report: report, test_file_pattern: "spec/**/*_spec.rb", ci_node_total: 2, ci_node_index: 0)
distributor.tests_for_current_node&.map(&:upcase)
distributor.tests_for_node(1)&.map(&:upcase)
distributor.node_time_execution.floor
distributor.sorted_report.each { |path, time| path.upcase + time.floor.to_s }

leftover = Knapsack::Distributors::LeftoverDistributor.new({ report: report, test_file_pattern: "spec/**/*_spec.rb", ci_node_total: "1", ci_node_index: "0" })
leftover.leftover_tests.map(&:upcase)
leftover.all_tests.map(&:upcase)

allocator = Knapsack::Allocator.new(report: report, test_file_pattern: "spec/**/*_spec.rb", ci_node_total: 1, ci_node_index: 0)
allocator.node_tests.map(&:upcase)
allocator.stringify_node_tests.upcase
allocator.test_dir.upcase

builder = Knapsack::AllocatorBuilder.new(Knapsack::Adapters::RSpecAdapter)
builder.test_dir.upcase
builder.allocator.report_node_tests&.map(&:upcase)

Knapsack::Adapters::RSpecAdapter.bind
adapter = Knapsack::Adapters::MinitestAdapter.bind
adapter.set_test_helper_path(__FILE__).upcase
Knapsack::Adapters::RSpecAdapter::TEST_DIR_PATTERN.upcase

Knapsack::Runners::CucumberRunner.run("--format progress")
Knapsack::Runners::SpinachRunner.run(nil)
Knapsack::Runners::MinitestRunner.run(nil)
Knapsack::Runners::RSpecRunner.run(nil)
