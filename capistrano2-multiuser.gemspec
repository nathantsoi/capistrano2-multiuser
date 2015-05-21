# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = 'capistrano2-multiuser'
  gem.version       = '0.0.2'
  gem.authors       = ['Nathan Tsoi']
  gem.email         = ['nathan@vertile.com']
  gem.description   = %q{Capistrano2 tasks for multiuser deployment configuration.}
  gem.summary       = %q{Sets deploy user to ENV['DEPLOY_USER'] and updates the deploy directory ownership to the current user and the deployment group then sets group permissions to match the current users' permissions}
  gem.homepage      = 'https://github.com/nathantsoi/capistrano2-multiuser'

  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'capistrano', '~> 2.0'

  gem.add_development_dependency 'rake'
end
