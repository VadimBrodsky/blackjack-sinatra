require 'rubygems'
require 'sinatra'

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
  CARDS = { '2' => 2, '3' => 3, '4' => 4, '5' => 5,
          '6' => 6, '7' => 7, '8' => 8, '9' => 9, '10' => 10,
          'jack' => 10, 'queen' => 10, 'king' => 10, 'ace' => [1, 11] }
  SUITS = { 'spades' => '♠', 'hearts' => '♥', 'diamonds' => '♦', 'clubs' => '♣' }

  def initialize
    @deck = CARDS.keys.product(SUITS.keys).shuffle
  end

  def to_s
    'I am a string'
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
