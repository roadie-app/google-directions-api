$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'vcr'
require 'dotenv'
require 'pry'
require 'google_directions_api'

Dotenv.load

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('<GOOGLE_API_KEY>'){ ENV['GOOGLE_API_KEY'] }
end

