#encoding: utf-8
class SessionsController < ApplicationController
  skip_before_filter :require_login, :only => :new
  def new
    if logged_in?
      redirect_to :overview
    end
  end
  
  def create
  user = User.authenticate(params[:email], params[:password])
  if user
    session[:user_id] = user.id
    redirect_to :overview, :notice => "Eingeloggt!"
  else
    flash.now.error = "Password oder E-Mail sind ungültig"
    render "new"
  end
end

def destroy
  session[:user_id] = nil
  redirect_to root_url, :notice => "Ausgeloggt!"
end
end
