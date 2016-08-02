class MyChat < Sinatra::Application
  get '/' do
    erb :my_chat
  end
end
