require 'rake/testtask'

desc "Run minitest specs"
Rake::TestTask.new :test do |t|
  t.pattern = 'test/*.rb'
end
task default: %w[test]

begin
  require 'buildar'

  Buildar.new do |b|
    b.gemspec_file = 'device_input.gemspec'
    b.version_file = 'VERSION'
    b.use_git = true
  end
rescue LoadError
  # ok
end
