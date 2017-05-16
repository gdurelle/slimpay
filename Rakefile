require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

desc 'Run RuboCop on the lib directory'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/slimpay.rb', 'lib/slimpay/*.rb', 'spec/**/*_spec.rb']
  task.formatters = ['progress']
  task.fail_on_error = false
  task.options = ["--config", ".rubocop.yml", "--force-exclusion"]
end

RSpec::Core::RakeTask.new(:spec)

task default: %i(rubocop spec)
