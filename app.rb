require 'sinatra'
require 'em-websocket'
require 'eventmachine'
#require 'sinatra/base'
require 'thin'
require 'active_support/all'
require 'mongo'
require 'json/ext'
require 'mongoid'

class MyChat < Sinatra::Application
  # enable :sessions # maybe it isn't required

  configure :production do
    # set :haml, { ugly: true }
    # set :clean_trace, true
  end

  configure :development do

  end

  configure do
    set :threaded, false
  end

  Mongoid.load!("mongoid.yml")

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end
end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'
