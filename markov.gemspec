lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'markov/version'

Gem::Specification.new do |s|
  s.name          = 'markov-ruby'
  s.version       = Markov::VERSION
  s.date          = %q{2016-07-05}
  s.summary       = "A postgresql backed markov text generator."
  s.description   = "A postgresql backed markov text generator."
  s.authors       = ["rob allen"]
  s.email         = 'rob.all3n@gmail.com'
  s.files         = Dir["{bin,lib}/**/*"]
  s.require_paths = ['lib']
  s.homepage      = ''
  s.license       = 'MIT'
  s.add_runtime_dependency 'engtagger', '0.2.0'
  s.add_runtime_dependency 'pg', '0.18.4'
  s.add_development_dependency "bundler", "~> 1.7"
  s.add_development_dependency "guard", "2.14.0"
  s.add_development_dependency "guard-minitest", "2.4.5"
  s.add_development_dependency "byebug", "9.0.5"
end