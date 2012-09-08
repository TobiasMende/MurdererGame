#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :require_login
  helper_method :current_user

private

def require_login
  unless logged_in?
    flash[:error] = "Du musst dich für diese Aktion einloggen!"
    redirect_to "sign_up"
  end
end

def current_user
  @current_user ||= User.find(session[:user_id]) if session[:user_id]
end

def logged_in?
   !!current_user
end
end
