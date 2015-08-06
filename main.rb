require 'rubygems'
require 'sinatra'

# set :sessions, true
use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'the_secret_of_secrets'


module PlayerHelpers
  def logged_in?
    !session[:player_name].nil?
  end
end

helpers PlayerHelpers

get '/' do
  erb :home
end

get '/game/new/?' do
  'new game'
  logged_in?.to_s
end

get '/player/new/?' do
  'new player'
end
