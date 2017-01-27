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

rprof_options = {
  min_percent: 2,
  printer: :graph,
  mode: :process,
  sort: :self,
}.inject('') { |memo, (flag,val)| memo + "--#{flag}=#{val} " }

evdump_options = {
  count: 9999,
  print: 'off',
}.inject('') { |memo, (flag,val)| memo + "--#{flag} #{val} " }

# this runs against the installed gem lib, not git / filesystem
desc "Run ruby-prof on bin/evdump (9999 events)"
task "ruby-prof" => "loadavg" do
  sh "ruby-prof #{rprof_options} \
                bin/evdump -- #{evdump_options} \
                              /dev/zero \
        | tee metrics/ruby-prof"
end

# this runs against the installed gem lib, not git / filesystem
desc "Run ruby-prof with --exclude-common-cycles"
task "ruby-prof-exclude" => "loadavg" do
  sh "ruby-prof #{rprof_options} \
                --exclude-common-cycles \
                bin/evdump -- #{evdump_options} \
                              /dev/zero \
        | tee metrics/ruby-prof-exclude"
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
