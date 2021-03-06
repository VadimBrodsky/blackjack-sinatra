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
  @player.reset_hand!
  @dealer = Dealer.new
  set_bet
  set_deck

  # TODO: Encapsulate to Helper
  @player.hand = @deck.deal(2)
  @dealer.hand = @deck.deal(2)
  check_player_hand

  save_game_state
  redirect to('/game')
end

post '/game/new' do
  protected!
  @player = load_player
  reset_deck!
  reset_player!
  save_player
  redirect to('/game/bet/new/')
end

get '/game/?' do
  protected_game_action!
  check_player_hand
  check_dealer_hand
  erb :'game/game'
end

post '/game/action/player/hit' do
  protected_game_action!
  player_hit
  check_player_hand
  save_game_state
  redirect to('/game')
end

post '/game/action/player/stay' do
  protected_game_action!
  @player.set_stand_status
  @dealer.open_hand
  save_game_state
  flash[:info] = 'You have chosen to stay!'
  redirect to('/game')
end

post '/game/action/dealer/hit' do
  protected_game_action!
  dealer_hit
  check_dealer_hand
  save_game_state
  redirect to('/game')
end

post '/game/compare/?' do
  protected_game_action!
  determine_winner
  save_game_state
  redirect to('/game/end')
  # @start_new_game = true
  # erb :'game/game'
end

get '/game/end/?' do
  protected_game_action!
  if !@player.playing? || !@dealer.playing?
    @start_new_game = true
    erb :'game/game'
  else
    redirect to('/game/bet/new')
  end
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
  if @player.name.strip.empty?
    flash[:error] = 'Name cannot be blank'
    redirect to('/player/new')
  end
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
