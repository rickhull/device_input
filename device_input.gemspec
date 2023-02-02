Gem::Specification.new do |s|
  s.name = 'device_input'
  s.summary = 'Read input events from e.g. /dev/input/event0'
  s.description = <<EOF
Pure ruby to read input events from the Linux kernel input device subsystem.
No dependencies.  Ruby 2+ required
EOF
  s.authors = ["Rick Hull"]
  s.homepage = 'https://github.com/rickhull/device_input'
  s.license = 'GPL-3.0'

  s.required_ruby_version = ">= 2.3"

  s.version = File.read(File.join(__dir__, 'VERSION')).chomp

  s.files  = %w[device_input.gemspec VERSION README.md Rakefile]
  s.files += Dir['lib/**/*.rb']
  s.files += Dir['test/**/*.rb']
  s.files += Dir['bin/**/*.rb']

  s.executables = ['evdump']

  s.add_runtime_dependency 'slop', '~> 4.0'
end
