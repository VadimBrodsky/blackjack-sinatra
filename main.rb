require 'rubygems'
require 'sinatra'

# set :sessions, true

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'the_secret_of_secrets'
