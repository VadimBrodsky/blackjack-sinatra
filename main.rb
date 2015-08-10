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

helpers PlayerHelpers

get '/' do
  erb :home
end

get '/game/new/?' do
  if player_known?
    'play game'
  else
    redirect '/player/new'
  end
end

get '/player/new/?' do
  'new player'
end
