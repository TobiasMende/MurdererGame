#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_login
  helper_method :current_user

def oauth
    @oauth ||= Koala::Facebook::OAuth.new(530109983701979, "2b0d3f2f4d7889efe9980a1fffff5211")
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
