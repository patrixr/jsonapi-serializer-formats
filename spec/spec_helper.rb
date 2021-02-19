require 'ffaker'
require 'rspec'
require 'byebug'
require 'jsonapi/serializer'
require 'jsonapi-serializer-formats'

Dir[
  File.expand_path('spec/fixtures/*.rb')
].sort.each { |f| require f }

RSpec.configure do |config|

end
