require_relative 'test_helper'

describe 'Main Application Interactions' do
  it 'should successfully render the homepage' do
    get '/'
    last_response.ok?.must_equal true
    last_response.body.must_include 'Blackjack <small>a Sinatra Webapp</small>'
  end

  describe 'player is not initialized' do
    def setup
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

    describe 'player tries to view the status of the game' do
      it 'should redirect to player creation' do
        get '/game'
        redirect_to_player_creation
      end
    end
  end

  describe 'player is initialized' do
    def setup
      app.clear_cookies
      post '/player', 'player_name' => 'Vadim'
      last_response.status.must_equal 302
    end

    describe 'player views the profile page' do
      it 'should render the player name' do
        get '/player'
        last_response.ok?.must_equal true
        last_response.body.must_include '<h1>Vadim</h1>'
      end
    end

    describe 'player goes to create a player page again' do
      it 'should redirect to player profile page' do
        get '/player/new'
        last_response.status.must_equal 302
        follow_redirect!
        last_request.url.must_equal 'http://example.org/player'
      end
    end

    describe 'player did not enter a bet' do
      describe 'player starts a new game' do
        it 'should redirect the player to enter a bet' do
          get '/game/new'
          last_response.status.must_equal 302
          follow_redirect!
          last_request.url.must_equal 'http://example.org/game/bet/new'
        end
      end

      describe 'player views the game status page' do
        it 'should redirect the player to enter a bet' do
          get '/game'
          last_response.status.must_equal 302
          follow_redirect!
          last_request.url.must_equal 'http://example.org/game/new'
        end
      end

      describe 'player views the bet page' do
        it 'should redirect the player to enter a bet' do
          get 'game/bet'
          last_response.status.must_equal 302
          follow_redirect!
          last_request.url.must_equal 'http://example.org/player'
        end
      end
    end

    describe 'player enters a bet' do
      def redirect_to_make_bet
        last_response.status.must_equal 302
        follow_redirect!
        last_request.url.must_equal 'http://example.org/game/bet/new'
      end

      describe 'player enters non numeric bet' do
        it 'should redirect to make a bet' do
          post '/game/bet', 'bet' => 'hello'
          redirect_to_make_bet
        end
      end

      describe 'player enters a negative number' do
        it 'should redirect to make a bet' do
          post '/game/bet', 'bet' => '-100'
          redirect_to_make_bet
        end
      end

      describe 'player tries to bet more than he has' do
        it 'should redirect to make a bet' do
          post '/game/bet', 'bet' => '99999999'
          redirect_to_make_bet
        end
      end

      describe 'player enters a bet of 0' do
        it 'should redirect to make a bet' do
          post '/game/bet', 'bet' => '0'
          redirect_to_make_bet
        end
      end

      describe 'player enters a valid bet' do
        it 'should redirect to new game page' do
          post '/game/bet', 'bet' => '200'
          last_response.status.must_equal 302
          follow_redirect!
          last_request.url.must_equal 'http://example.org/game/new'
        end
      end
    end
  end
end
