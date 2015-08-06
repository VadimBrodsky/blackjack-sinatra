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

# Examples of Sinatra Responses

get '/inline' do
  "Response, directly from a Sinatra action"
end

get '/template' do
  erb :mytemplate
end

get '/nested_template' do
  ebr :'/users/profile'
end

get '/nothere' do
  redirect '/inline'
end
