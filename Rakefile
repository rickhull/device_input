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

desc "Generate code metrics reports"
task :code_metrics => [:flog, :flay, :roodi]

desc "Run flog on lib/"
task :flog do
  puts
  sh "flog lib | tee metrics/flog"
end

desc "Run flay on lib/"
task :flay do
  puts
  sh "flay lib | tee metrics/flay"
end

desc "Run roodi on lib/"
task :roodi do
  puts
  sh "roodi lib | tee metrics/roodi"
end
