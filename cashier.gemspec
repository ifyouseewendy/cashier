# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cashier/version'

Gem::Specification.new do |spec|
  spec.name          = "cashier"
  spec.version       = Cashier::VERSION
  spec.authors       = ["Di Wen"]
  spec.email         = ["ifyouseewendy@gmail.com"]

  spec.summary       = %q{A simulated cash machine.}
  spec.description   = %q{A simulated cash machine, only support print right now.}
  spec.homepage      = "https://github.com/ifyouseewendy/cashier"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.3.0'
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
