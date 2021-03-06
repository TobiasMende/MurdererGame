class AssignmentsController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def destroy
  end

  def show
  end

  def edit
  end
  
  

  def post
    a = Assignment.find(params[:id])
    unless params[:code].nil?
      oauth(post_assignment_url(a)).url_for_access_token(params[:code])
      info = oauth(post_assignment_url(a)).get_access_token_info(params[:code])
      puts info
      current_user.facebook_access_token = info["access_token"]
      current_user.facebook_oauth_expires_at = DateTime.now + info["expires"].to_i.seconds
      current_user.save!
    end
      token = current_user.facebook_access_token
    unless a.nil? || token.nil?
      @graph = Koala::Facebook::API.new(token)
      @graph.put_connections("me", "feed", :message => "ist dem Spiel \""+a.game.title+"\" beigetreten.",
                                           :link => game_url(a.game), 
                                           :name => a.game.title, 
                                           :caption => a.game.description, 
                                           :description => "Worauf wartest du noch? - Melde dich an!")

    end
    flash[:notice] = "Teilnahme erfolgreich!"
    unless a.nil?
      redirect_to game_path(a.game)
    else
      redirect_to :overview
    end
  end
end
