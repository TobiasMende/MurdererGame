#encoding: utf-8
class GamesController < ApplicationController
  helper_method :sort_column, :sort_direction
  def index
    @games = Game.order(sort_column + " " + sort_direction)
  end

  def create
  end

  def new
  end

  def destroy
  end

  def show
    @game = Game.find(params[:id])
    @cu = current_user

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  def open
    @games = Game.open_games.order(sort_column + " " + sort_direction)
    @cu = current_user
  end

  def highscore
    @game = Game.find(params[:id])
    @cu = current_user
  end

  def assign
    @game = Game.find(params[:id])
    if !@game.joinable?(current_user)
      flash[:error] = "Teilnahme ist nicht mehr möglich!"
      redirect_to :back
    end
    a = Assignment.new
    a.user = current_user
    a.game = @game

    if a.save
      flash[:notice] = "Teilnahme erfolgreich!"
      unless current_user.facebook_id.nil?
        redirect_to oauth.url_for_oauth_code(:permissions => "publish_stream", :callback => post_game_assignment_url(a))
      else
        redirect_to :back
      end
    end

    def post_assignment
      a = Assignment.find(params[:id])
      puts a.to_yaml
      token = oauth.get_access_token(params[:code])
      unless a.nil? || token.nil?
        @graph = Koala::Facebook::API.new(token)
        @graph.put_connections("me", "feed", :message => "ist dem Spiel "+a.game.title+" beigetreten.")
        
      end
      unless a.nil?
        redirect_to game_path(a.game)
      else
        redirect_to :overview
      end
    end

  # respond_to do |format|
  # format.html # show.html.erb
  # format.json { render json: @game }
  # end
  end

  private

  def sort_column
    Game.column_names.include?(params[:sort]) ? params[:sort] : "game_start"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
