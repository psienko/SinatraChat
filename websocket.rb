class Websocket
  def run(host: '0.0.0.0', port: '8081')
    @channel = EM::Channel.new
    @users = {}
    @messages = []

    EventMachine::WebSocket.start(host: host, port: port) do |ws|
      ws.onopen do
        sid = @channel.subscribe { |msg| ws.send msg }

        # Add new user
        @users[ws.object_id] = sid

        # Push messages to the user
        @messages.each do |message|
          ws.send message.to_json
        end
      end

      ws.onmessage do |msg|
        params = JSON.parse(msg).with_indifferent_access
        if params[:service_type] == 'chat'
          message = Message.new(nickname: params[:nickname], content: params[:content])
          @messages << message
          @messages.shift if @messages.length > 10
          @channel.push message.to_json
        end
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
    end
  end
end
