require 'rake/testtask'
require 'rubocop/rake_task'

Rake::TestTask.new do |task|
  task.pattern = 'test/*_specs.rb'
end

desc 'Run rubocop'
task :rubocop do
  RuboCop::RakeTask.new
end

desc 'Run App'
task :run do
  system 'shotgun main.rb'
end

task default: :run
