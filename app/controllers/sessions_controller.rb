class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    puts auth
    user = User.find_by_fb_id(auth['extra']['raw_info']['id'].to_i) 
    if user.nil?
      user = User.create_with_omniauth(auth)
    end
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in!"
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end
