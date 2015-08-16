require 'rubygems'
require 'sinatra'
require 'json'
require 'sinatra/flash'

require_relative 'lib/deck'
require_relative 'lib/player'
require_relative 'lib/dealer'
require_relative 'lib/helpers/player_helpers'
require_relative 'lib/helpers/dealer_helpers'
require_relative 'lib/helpers/deck_helpers'
require_relative 'lib/helpers/game_helpers'

# set :sessions, true
use Rack::Session::Cookie, key: 'blackjack',
                           path: '/',
                           secret: 'the_secret_of_secrets'

helpers PlayerHelpers
helpers DeckHelpers
helpers GameHelpers
helpers DealerHelpers

get '/' do
  @player = load_player
  erb :home
end

get '/game/new/?' do
  protected!
  @player = load_player
  @dealer = Dealer.new
  set_bet
  set_deck

  # TODO: Encapsulate to Helper
  @player.hand = @deck.deal(2)
  @dealer.hand = @deck.deal(2)

  save_game_state
  redirect to('/game')
end

get '/game/?' do
  protected!
  game_set!
  load_game_state
  erb :'game/game'
end

post '/game/hit' do
  protected!
  game_set!
  load_game_state
  @player.hand = @deck.deal
  save_game_state
  redirect to('/game')
end

post '/game/stay' do
  protected!
  game_set!
  load_game_state
  @player.stand
  @dealer.open_hand
  save_game_state
  redirect to('/game')
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
  process_bet(params[:bet].to_i)
  redirect to 'game/new'
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

# Debug only paths
if settings.development?
  get '/debug/session' do
    session[:player]
    session.inspect.to_s
  end
end
