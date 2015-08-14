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

  def protected!
    unless player_known?
      redirect to('/player/new')
    end
  end

  def load_player
    if player_known?
      Player.new.load_from_session(session[:player])
    end
  end

  def save_player
    session[:player] = @player.save_to_session
  end
end


helpers PlayerHelpers

get '/' do
  @player = load_player
  erb :home
end

get '/game/new/?' do
  protected!
  @player = load_player
  if @player.bet <= 0
    redirect to('/game/bet/new')
  else
    @deck = Deck.new
    session[:deck] = @deck.to_json
    erb :'game/new'
  end
end

get '/game/bet/new/?' do
  protected!
  @player = load_player
  erb :'game/bet/new'
end

post '/game/bet' do
  protected!
  @player = load_player
  bet = params[:bet].to_i
  if @player.valid_bet?(bet)
    @player.bet = bet
    save_player
    redirect to 'game/new'
  else
    redirect to '/game/bet/new'
  end
end

get '/game/?' do

end

get '/player/?' do
  protected!
  @player = load_player
  erb :'player/player'
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
  session[:player]
  session.inspect.to_s
end
