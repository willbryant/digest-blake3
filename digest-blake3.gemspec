lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "digest/blake3/version"

Gem::Specification.new do |spec|
  spec.name          = "digest-blake3"
  spec.version       = Digest::BLAKE3::VERSION
  spec.authors       = ["Will Bryant"]
  spec.email         = ["will.bryant@gmail.com"]

  spec.summary       = %q{BLAKE3 for Ruby}
  spec.description   = %q{Self-contained C implementation of BLAKE3.}
  spec.homepage      = "https://github.com/willbryant/digest-blake3"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "ext"]
  spec.extensions    = %w[ext/digest/blake3/extconf.rb]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.0"
end
