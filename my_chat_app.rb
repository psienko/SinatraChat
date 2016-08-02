require 'sinatra'
require 'pry'
require 'json'
#require 'socket'
#require 'actioncable'

get '/' do
  # 'Hello world!'
  erb :my_chat
end

get '/chat' do
  binding.pry
  # binding.pry
  # # Wait for a connection
  # socket = server.accept
  # STDERR.puts "Incoming Request"
  #
  # # Read the HTTP request. We know it's finished when we see a line with nothing but \r\n
  # http_request = ""
  # while (line = socket.gets) && (line != "\r\n")
  #   http_request += line
  # end
  # STDERR.puts http_request
  # socket.close
end
