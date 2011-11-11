require './config/initialize'
require 'sinatra'

set :run, false
set :environment, :production

require 'server.rb'
run Sinatra::Application
