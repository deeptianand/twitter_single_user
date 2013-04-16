get '/' do
  erb :index
end

post '/tweet' do

  # user from twitter using the access key
  Twitter.update(params[:tweet])
  sleep 3
  params[:tweet]
end
