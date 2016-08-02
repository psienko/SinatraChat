require 'rubygems'
require 'em-websocket'
#require 'yajl'
#require 'haml'
require 'sinatra/base'
require 'thin'
require 'json'
require 'pry'

EventMachine.run do
  class App < Sinatra::Base
    get '/' do
      erb :my_chat
    end

    @channel = EM::Channel.new
    @users = {}
    @messages = []

    EventMachine::WebSocket.start(host: '0.0.0.0', port: 8081) do |ws|
      ws.onopen do
        sid = @channel.subscribe { |msg| ws.send msg }

        # Add new user
        @users[ws.object_id] = sid

        # Push messages to the user
        @messages.each do |message|
          ws.send message
        end

        # Broadcast ht notification to all users
        # @channel.push({
        #   nickname:  '',
        #   message:   "New user joined. #{@users.length} in chat",
        #   timestamp: Time.now.strftime("%H:%M:%S")
        # }.to_json)
      end

      ws.onmessage do |msg|
        binding.pry
        # Add the timestamp to the message
        # message = JSON.parse(msg).merge(timestamp: Time.now.strftime("%H:%M:%S")).to_json
        #
        # # Append the massage at the end of the queue
        # @messages << message
        # @messages.shift if @messages.length > 10
        #
        # # Broadcast the message to all users connected to the channel
        # @channel.push message
      end

      ws.onclose do
        @channel.unsubscribe @users[ws.object_id]
        @users.delete(ws.object_id)

        # Broadcast the notification to all users
        @channel.push({
          nickname: '',
          message: "One user left. #{@users.length} users in chat",
          timestamp: Time.now.strftime("%H:%M:%S")
        }.to_json)
      end

        #@channel.push "#{sid} connected!"

        # ws.onmessage do |msg|
        #   @channel.push "<#{sid}>: #{msg}"
        # end

      #   ws.onclose do |msg|
      #     @channel.unsubscribe(sid)
      #   end
      # end
    end
  end

  App.run!({port: 4567}) # It couses lack of ability to close thin server because "Thin was started insinde an existing EventMachine.run block"
end
