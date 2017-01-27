require 'rake/testtask'

task default: :test

desc "Run minitest specs with code coverage"
Rake::TestTask.new :test do |t|
  t.pattern = 'test/*spec.rb'
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

# this runs against the installed gem lib, not git / filesystem
desc "Run ruby-prof on bin/evdump (9999 events)"
task "ruby-prof" => "loadavg" do
  sh ["ruby-prof -m1 -p graph",
      "bin/evdump -- -c 9999 -p off /dev/zero",
      "| tee metrics/ruby-prof"].join(' ')
end

# this runs against the installed gem lib, not git / filesystem
desc "Run ruby-prof with --exclude-common-cycles"
task "ruby-prof-exclude" => "loadavg" do
  sh ["ruby-prof -m1 -p graph --exclude-common-cycles",
      "bin/evdump -- -c 9999 -p off /dev/zero",
      "| tee metrics/ruby-prof-exclude"].join(' ')
end

desc "Show current system load"
task "loadavg" do
  puts File.read "/proc/loadavg"
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
