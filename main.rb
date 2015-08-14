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

  def load_player
    Player.new.load_from_session(session[:player])
  end

  def save_player
    session[:player] = @player.save_to_session
  end
end


helpers PlayerHelpers

get '/' do
  erb :home
end

get '/game/new/?' do
  if player_known?
    @player = load_player
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
  if player_known?
    @player = load_player
    erb :'player/player'
  else
    redirect 'player/new'
  end
end

get '/player/new/?' do
  erb :'player/new'
end

post '/player' do
  @player = Player.new(name: params[:player_name])
  save_player
  redirect to('/player')
end

delete '/player' do
  session.clear
  redirect to('/')
end

get '/session' do
  session.inspect.to_s
end
