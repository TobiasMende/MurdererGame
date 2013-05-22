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
      puts "2: "+oauth.oauth_callback_url unless oauth.oauth_callback_url.nil?
      oauth.url_for_access_token(param[:code], post_assignment_url(a))
      puts "3: "+oauth.oauth_callback_url unless oauth.oauth_callback_url.nil?
      token = oauth.get_access_token(params[:code])
      puts "4: "+oauth.oauth_callback_url unless oauth.oauth_callback_url.nil?
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
end
