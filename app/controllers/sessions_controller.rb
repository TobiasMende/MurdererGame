#encoding: utf-8
class SessionsController < ApplicationController
  before_filter :require_login, :only => :destroy
  def new
    if logged_in?
      redirect_to :overview
    end
  end
  
  def create
  user = User.authenticate(params[:email], params[:password])
  if user
    session[:user_id] = user.id
    user.update_column("last_login", DateTime.now)
    flash[:notice] = "Eingeloggt!"
    redirect_to :overview
  else
    flash[:error] = "Password oder E-Mail sind ungültig"
    redirect_to sessions_new_path
  end
end

def destroy
  session[:user_id] = nil
  flash[:notice] = "Ausgeloggt!"
  redirect_to root_url
end
end
