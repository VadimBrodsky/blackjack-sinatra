require_relative 'test_helper'

describe 'Main Application Interactions' do
  it 'should successfully render the homepage' do
    get '/'
    last_response.ok?.must_equal true
    last_response.body.must_include 'Blackjack <small>a Sinatra Webapp</small>'
  end

  describe 'player is not initialized' do
    before do
      app.clear_cookies
    end

    def redirect_to_player_creation
      last_response.status.must_equal 302
      follow_redirect!
      last_request.url.must_equal 'http://example.org/player/new'
    end

    describe 'player starts a new game' do
      it 'should redirect to player creation' do
        get '/game/new'
        redirect_to_player_creation
      end
    end

    describe 'player tries to view the profile page' do
      it 'should redirect to player creation' do
        get '/player'
        redirect_to_player_creation
      end
    end

    describe 'player tries to make a bet' do
      it 'should redirect to player creation' do
        get '/game/bet/new'
        redirect_to_player_creation
      end
    end
  end
end
