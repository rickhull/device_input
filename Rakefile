require 'rake/testtask'
desc "Run tests"
Rake::TestTask.new :test do |t|
  t.pattern = 'test/*spec.rb'
  t.warning = true
end

task default: :test


#
# METRICS
#

metrics_tasks = []

begin
  require 'flog_task'

  # we want: flog --all --methods-only lib
  # but: FlogTask doesn't support the equivalent of --all; oh well
  methods_only = true
  FlogTask.new(:flog, 200, ['lib'], nil, methods_only) do |t|
    t.verbose = true
  end
  metrics_tasks << :flog
rescue LoadError
  warn 'flog_task unavailable'
end

begin
  require 'flay_task'

  # we want: flay --liberal lib
  # but: FlayTask doesn't support the equivalent of --liberal; oh well
  FlayTask.new do |t|
    t.dirs = ['lib']
    t.verbose = true
  end
  metrics_tasks << :flay
rescue LoadError
  warn 'flay_task unavailable'
end

begin
  require 'roodi_task'
  RoodiTask.new patterns: ['lib/**/*.rb']
  metrics_tasks << :roodi
rescue LoadError
  warn 'roodi_task unavailable'
end

desc "Generate code metrics reports"
task :code_metrics => metrics_tasks


#
# PROFILING
#

desc "Show current system load"
task "loadavg" do
  puts File.read "/proc/loadavg"
end

# make sure command is run against lib/ on the filesystem, not an installed gem
def lib_sh(cmd)
  sh "RUBYLIB=lib #{cmd}"
end

# set up script, args, and rprof_args the way ruby-prof wants them
def rprof_sh(script, args, rprof_args = '')
  lib_sh ['ruby-prof', rprof_args, script, '--', args].join(' ')
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
}.inject('') { |memo, (flag,val)| memo + "--#{flag} #{val} " } + '/dev/zero'

desc "Run ruby-prof on bin/evdump (9999 events)"
task "ruby-prof" => "loadavg" do
  puts
  rprof_sh 'bin/evdump', evdump_options, rprof_options
end

desc "Run ruby-prof with --exclude-common-cycles"
task "ruby-prof-exclude" => "ruby-prof" do
  puts
  rprof_sh 'bin/evdump', evdump_options,
           "#{rprof_options} --exclude-common-cycles"
end

task "no-prof" do
  lib_sh "bin/evdump #{evdump_options}"
end


#
# GEM BUILD / PUBLISH
#

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
