ENV['RACK_ENV'] = 'test'
require_relative '../main'
require 'minitest/autorun'
require 'minitest/pride'
require 'rack/test'

include Rack::Test::Methods

def app
  Sinatra::Application
end
