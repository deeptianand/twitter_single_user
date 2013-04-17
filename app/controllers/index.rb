require 'pry'

get '/' do
  erb :index
end


get '/oauth' do
  # if session[:user]
  #   redirect '/' 
  
  # else 
  session.delete(:user)
  @consumer = OAuth::Consumer.new(YOUR_CONSUMER_KEY ,YOUR_CONSUMER_SECRET, :site => "https://api.twitter.com")
   
  session[:request_token] = @consumer.get_request_token(:oauth_callback => "http://127.0.0.1:9292/auth")

   redirect session[:request_token].authorize_url
 # end
end

get '/auth' do
  
  access_token = session[:request_token].get_access_token(:oauth_verifier => params[:oauth_verifier])
  session.delete(:request_token)

  client = Twitter::Client.new(
    :consumer_key => YOUR_CONSUMER_KEY,
    :consumer_secret => YOUR_CONSUMER_SECRET,
    :oauth_token => access_token.token,
    :oauth_token_secret => access_token.secret
  )
 
  user = User.create(:twitter_token=>client.oauth_token, :twitter_secret=>client.oauth_token_secret)
 
  # session[:user] = user


  redirect '/'
end


post '/tweet' do
  # user from twitter using the access key
  session[:client].update(params[:tweet])
  sleep 1
  200
end
