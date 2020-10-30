
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "git_swap/version"

Gem::Specification.new do |spec|
  spec.name          = "git_swap"
  spec.version       = GitSwap::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Randall Reed, Jr."]
  spec.email         = ["randallreedjr@gmail.com"]

  spec.summary       = %q{Swap between git profiles}
  spec.description   = %q{Easily swap between git profiles (name, username, email) and ssh keys}
  spec.homepage      = "https://www.github.com/randallreedjr/git_swap"
  spec.license       = "MIT"

  spec.files = [
    'lib/git_swap.rb',
    'lib/git_swap/swapper.rb',
    'lib/git_swap/git_helper.rb',
    'lib/git_swap/config.rb',
    'lib/git_swap/options.rb',
    'lib/git_swap/version.rb',
    'bin/git-swap'
  ]

  spec.executables   << 'git-swap'
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", "~> 5.2"

  spec.add_development_dependency "bundler", "~> 2.1.4"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.4.1"
end
