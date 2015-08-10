require_relative 'test_helper'

describe 'Main Application Interactions' do
  it 'should successfully render the homepage' do
    get '/'
    last_response.ok?.must_equal true
    last_response.body.must_include 'Blackjack <small>a Sinatra Webapp</small>'
  end

  describe 'when player was not initialized' do
    before do
      app.clear_cookies
    end

    it 'should redirect to player creation' do
      get '/game/new'
      last_response.status.must_equal 302
      follow_redirect!
      last_request.url.must_equal 'http://example.org/player/new'
    end
  end

end
