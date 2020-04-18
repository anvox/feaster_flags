
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "feaster_flags/version"

Gem::Specification.new do |spec|
  spec.name          = "feaster_flags"
  spec.version       = FeasterFlags::VERSION
  spec.authors       = ["anvox"]
  spec.email         = ["thien.an.vo.nguyen@gmail.com"]

  spec.summary       = 'A small DSL to provide feature flags function'
  spec.description   = 'A small DSL to provide feature flags function'
  spec.homepage      = 'https://github.com/anvox/feaster_flags'
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = 'https://github.com/anvox/feaster_flags'
    spec.metadata["changelog_uri"] = 'https://github.com/anvox/feaster_flags/CHANGELOG.md'
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "redis"#, '< 7.0', '>= 4.2.0'
  # spec.add_runtime_dependency "activesupport", '< 7.0', '>= 4.2.0'
  # spec.add_runtime_dependency "activerecord", '< 7.0', '>= 4.2.0'

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_runtime_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
