require 'rake/testtask'

task default: :test

desc "Run minitest specs with code coverage"
Rake::TestTask.new :test do |t|
  t.pattern = 'test/*.rb'
end

desc "Generate code metrics reports"
task :code_metrics => [:test, :flog, :flay, :roodi]

desc "Run flog on lib/"
task :flog do
  puts
  sh "flog --all --methods-only lib | tee metrics/flog"
end

desc "Run flay on lib/"
task :flay do
  puts
  sh "flay --liberal --verbose lib | tee metrics/flay"
end

desc "Run roodi on lib/"
task :roodi do
  puts
  sh "roodi lib | tee metrics/roodi"
end

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
