Gem::Specification.new do |s|
  s.name        = 'jsonapi-serializer-formats'
  s.version     = '0.0.5'
  s.summary     = "Adds 'formats' to JSON::API Serializers"
  s.description = <<-EOF
    A module to enrich JSON:API Serializers (https://github.com/jsonapi-serializer) with configurable formats
  EOF
  s.authors     = ["Patrick Rabier"]
  s.email       = 'patrick@tronica.io'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/patrixr/jsonapi-serializer-formats'
  s.license     = 'MIT'

  s.add_runtime_dependency('jsonapi-serializer', '>= 2.1')
  s.add_runtime_dependency('activesupport', '>= 4.2')

  s.add_development_dependency('bundler')
  s.add_development_dependency('byebug')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('ffaker')
end
