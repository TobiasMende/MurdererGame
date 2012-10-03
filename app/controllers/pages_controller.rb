class PagesController < ApplicationController
  skip_before_filter :require_login, :only => [:index]
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
end
