require 'rubygems'
require 'sinatra'

# set :sessions, true

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'the_secret_of_secrets'

get '/' do
  erb :home
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
