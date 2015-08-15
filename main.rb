require 'rubygems'
require 'sinatra'
require 'json'
require 'sinatra/flash'

require_relative 'lib/deck'
require_relative 'lib/player'
require_relative 'lib/helpers/player_helpers'
require_relative 'lib/helpers/deck_helpers'
require_relative 'lib/helpers/game_helpers'

# set :sessions, true
use Rack::Session::Cookie, key: 'blackjack',
                           path: '/',
                           secret: 'the_secret_of_secrets'

helpers PlayerHelpers
helpers DeckHelpers
helpers GameHelpers

get '/' do
  @player = load_player
  erb :home
end

get '/game/new/?' do
  protected!
  @player = load_player
  set_bet
  set_deck

  # TODO: Add dealer
  # TODO: Encapsulate to Helper
  @player.hand = @deck.deal(2)

  # TODO: Encapsulate to Helper
  save_player
  save_deck

  redirect to('/game')
end

get '/game/?' do
  protected!
  game_set!
  @player = load_player
  @deck = load_deck
  erb :'game/game'
end

get '/game/bet/new/?' do
  protected!
  @player = load_player
  erb :'game/bet/new'
end

get '/game/bet/?' do
  redirect to('/player')
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

get '/player/?' do
  protected!
  @player = load_player
  erb :'player/player'
end

get '/player/new/?' do
  if player_known?
    redirect to('/player')
  else
    erb :'player/new'
  end
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
