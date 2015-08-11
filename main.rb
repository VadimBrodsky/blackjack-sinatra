require 'rubygems'
require 'sinatra'
require 'json'

# set :sessions, true
use Rack::Session::Cookie, key: 'rack.session',
                           path: '/',
                           secret: 'the_secret_of_secrets'

module PlayerHelpers
  def player_known?
    !session[:player_name].nil?
  end
end

class Deck
  attr_accessor :cards

  CARDS = { '2' => 2, '3' => 3, '4' => 4, '5' => 5,
          '6' => 6, '7' => 7, '8' => 8, '9' => 9, '10' => 10,
          'j' => 10, 'q' => 10, 'k' => 10, 'a' => [1, 11] }
  SUITS = { 's' => 'spades', 'h' => 'hearts', 'd' => 'diamonds', 'c' => 'clubs' }

  def initialize(data=nil)
    if data.nil?
      self.cards = CARDS.keys.product(SUITS.keys).shuffle
    else
      self.cards = data
    end
  end

  def to_s
    cards.to_s
  end

  def to_json
    cards.to_json
  end
end

helpers PlayerHelpers

get '/' do
  erb :home
end

get '/game/new/?' do
  if player_known?
    @player_name = session[:player_name]
    @deck = Deck.new
    erb :'game/new'
  else
    redirect '/player/new'
  end
end

get '/player/?' do
  "Howdy #{session[:player_name]}"
end

get '/player/new/?' do
  'new player'
  erb :'player/new'
end

post '/player' do
  session[:player_name] = params[:player_name]
  redirect to('/player')
end
