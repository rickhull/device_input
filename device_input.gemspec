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
  s.files = %w(
README.md
lib/device_input.rb
lib/device_input/codes.rb
bin/devsniff
)
  s.executables = ['devsniff']
  s.add_development_dependency "buildar", "~> 2"
  s.required_ruby_version = "~> 2"

  s.version = File.read(File.join(__dir__, 'VERSION')).chomp
end
