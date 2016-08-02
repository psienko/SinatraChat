require 'sinatra'
require 'em-websocket'
require 'eventmachine'
#require 'sinatra/base'
require 'thin'
require 'active_support/all'

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

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end
end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'
