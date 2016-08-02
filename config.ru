root = ::File.dirname(__FILE__)
require ::File.join( root, 'app')
require ::File.join( root, 'websocket')
require 'json'
require 'pry'

def run(opts)
  EM.run do
    server  = opts[:server]  || 'thin'
    host    = opts[:host]    || '0.0.0.0'
    port    = opts[:port]    || '4567'
    ws_host = opts[:ws_host] || '0.0.0.0'
    ws_port = opts[:ws_port] || '8081'
    web_app = opts[:app]

    dispatch = Rack::Builder.app do
      map '/' do
        run web_app
        Websocket.new.run(host: ws_host, port: ws_port)
      end
    end

    unless %w(thin hatetepe goliath).include? server
      raise "Need an EM webserver, but #{server} isn't"
    end

    Rack::Server.start(
      app:    dispatch,
      server: server,
      Host:   host,
      Port:   port
    )
  end
end

run(app: MyChat.new)
