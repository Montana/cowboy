require 'sinatra'

get('/') { 'this is cowboy yeehaw!' }

get '/' do
  'Hello, Prowl!'
end

get '/hi' do
  'Hello, Prowl 2!'
end

get '/hi' do
  'Hello, Prowl 3!'
end

get '/hi' do
  'Hello, Prowl 4!'
end

post '/' do
  connections.each { |out| out << "data: #{params[:msg]}\n\n" }
  204 
end
