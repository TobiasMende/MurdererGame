#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_login
  helper_method :current_user

def oauth(callback)
  
    @oauth ||= Koala::Facebook::OAuth.new(APP_CONFIG['facebook_app_id'], APP_CONFIG['facebook_app_secret'], callback)
  end

private

def require_login
  unless logged_in?
    flash[:error] = "Du musst dich für diese Aktion einloggen!"
    redirect_to :log_in
  end
end

def current_user
  @current_user ||= User.find(session[:user_id]) if session[:user_id]
end


def logged_in?
   !!current_user
end
end
