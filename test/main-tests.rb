ENV['RACK_ENV'] = 'test'
require_relative '../main'
require 'minitest/autorun'
require 'rack/test'

class BlackJackTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_home_page_should_render
    get '/'
    assert last_response.ok?
    assert_includes last_response.body, '<h1>Blackjack <small>a Sinatra Webapp</small></h1>' 
  end

end
