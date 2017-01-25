require 'buildar'
require 'rake/testtask'

Buildar.new do |b|
  b.gemspec_file = 'device_input.gemspec'
  b.version_file = 'VERSION'
  b.use_git = true
end

task default: %w[test]

desc "Run minitest specs"
Rake::TestTask.new :test do |t|
  t.pattern = 'test/*.rb'
end
