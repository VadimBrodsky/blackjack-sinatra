require 'rubygems'
require 'sinatra'
require 'json'
require 'sinatra/flash'

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

  def set_bet
    if @player.bet <= 0
      redirect to('/game/bet/new')
    end
  end
end

module DeckHelpers
  def deck_set?
    !session[:deck].nil?
  end

  def load_deck
    Deck.new(JSON.parse(session[:deck]))
  end

  def save_deck
    session[:deck] = @deck.save_to_session
  end

  def set_deck
    if deck_set?
      redirect to('/game')
    else
      @deck = Deck.new
    end
  end
end

helpers PlayerHelpers
helpers DeckHelpers

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
  if player_known? && deck_set?
    @player = load_player
    @deck = load_deck
    erb :'game/game'
  else
    redirect to '/game/new'
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
