#encoding: utf-8
class GamesController < ApplicationController
  def index
  end

  def create
  end

  def new
  end

  def destroy
  end

 def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end
  
  def open
    @games = Game.open_games
    @cu = current_user
  end
  
  def assign
    @game = Game.find(params[:id])
    if !@game.joinable?
      flash[:error] = "Teilnahme ist nicht mehr möglich!"
      redirect_to :back
    end
    a = Assignment.new
    a.user_id = current_user
    a.game_id = @game
    
    if a.save
      flash[:notice] = "Teilnahme erfolgreich!"
      redirect_to :back
    end
    
    # respond_to do |format|
      # format.html # show.html.erb
      # format.json { render json: @game }
    # end
  end
end
