require 'rubygems'
require 'sinatra'
require 'json'

require_relative 'lib/deck'
require_relative 'lib/player'

# set :sessions, true
use Rack::Session::Cookie, key: 'blackjack',
                           path: '/',
                           secret: 'the_secret_of_secrets'

module PlayerHelpers
  def player_known?
    !session[:player].nil?
  end
end


helpers PlayerHelpers

get '/' do
  erb :home
end

get '/game/new/?' do
  if player_known?
    @player = Player.new.load_from_session(session[:player])
    @deck = Deck.new
    session[:deck] = @deck.to_json
    erb :'game/new'
  else
    redirect '/player/new'
  end
end

get '/game/?' do

end

get '/player/?' do
  "Howdy #{session[:player_name]}"
end

get '/player/new/?' do
  'new player'
  erb :'player/new'
end

post '/player' do
  session[:player] = Player.new(name: params[:player_name]).save_to_session
  redirect to('/player')
end

get '/session' do
  session[:session_id]
  session.inspect.to_s
end
