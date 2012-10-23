#encoding: utf-8
class PagesController < ApplicationController
  before_filter :require_login, :only => [:overview]
  def index
    if logged_in?
      redirect_to :overview
    end
  end
  
  def overview
    @current_user = current_user
    @current_games = @current_user.current_games
    @future_games = @current_user.future_games
    @finished_games = @current_user.finished_games
  end
  
  def rules
    
  end
  
  def impressum
    
  end
  
  def about_us
    
  end
  
  def supporters
    
  end
  
  def password_reset
     if logged_in?
      redirect_to :overview, notice: "Du bist eingeloggt und kannst dein Passwort nicht zurücksetzen."
    end
  end
end
