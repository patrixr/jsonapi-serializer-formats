Gem::Specification.new do |s|
  s.name        = 'jsonapi-serializer-formats'
  s.version     = '0.0.1'
  s.summary     = "Adds support for formats to serializers"
  s.description = "Adds support for formats to serializers"
  s.authors     = ["Patrick Rabier"]
  s.email       = 'patrick@tronica.io'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    =
    'https://rubygems.org/gems/jsonapi-serializer-formats'
  s.license       = 'MIT'

  s.add_runtime_dependency('jsonapi-serializer', '>= 2.1.0')
  s.add_runtime_dependency('activesupport', '>= 4.2')
  
  s.add_development_dependency('activerecord')
  s.add_development_dependency('bundler')
  s.add_development_dependency('byebug')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('ffaker')
  s.add_development_dependency('sqlite3')
end
