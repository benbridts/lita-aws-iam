Gem::Specification.new do |spec|
  spec.name          = 'lita-aws-iam'
  spec.version       = '0.1.0'
  spec.authors       = ['Stefan Goethals']
  spec.email         = ['stefan.goethals@vrt.be']
  spec.description   = 'Lita handler for managing IAM permissions'
  spec.summary       = 'Lita handler for managing IAM permissions'
  spec.homepage      = 'http://vrt.be'
  spec.license       = 'Apache'
  spec.metadata      = { 'lita_plugin_type' => 'handler' }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'aws-sdk-iam'
  spec.add_runtime_dependency 'json'
  spec.add_runtime_dependency 'lita', '>= 4.7'
  spec.add_runtime_dependency 'pry'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 3.0.0'
end
