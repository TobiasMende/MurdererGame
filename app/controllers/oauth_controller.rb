# coding: utf-8
class OauthController < ApplicationController
  def init_default
    redirect_to oauth.url_for_oauth_code(:permissions => "publish_stream")
  end

  def callback_default
    #TODO delete debug statements
    token = oauth.get_access_token(params[:code])
    puts token
    respond_to do |format|
      if !token.nil?
        @graph = Koala::Facebook::API.new(token)
        profile = @graph.get_object("me")
        id = profile["id"]
        if id.nil?
          puts "No Facebook ID was returned!"
          format.html { redirect_to edit_user_path(current_user), error: 'Die Verknüpfung mit Facebook ist fehlgeschlagen!' }
          format.json { render json: edit_user_path(current_user), status: :unprocessable_entity, location: :overview }
        else
          current_user.facebook_id = id.to_i
          puts "Current User: "+current_user.to_yaml
          if current_user.save
            puts "Saving was successful"
            format.html { redirect_to edit_user_path(current_user), notice: 'Dein Account wurde erfolgreich mit Facebook verknüpft.' }
          else
            puts "An error occured while saving current user."
            format.html { redirect_to edit_user_path(current_user), error: 'Ein Fehler ist aufgetreten. Bitte versuche es erneut!' }
            format.json { render json: edit_user_path(current_user), status: :unprocessable_entity, location: :overview }
          end
        end
      else
        format.html { redirect_to edit_user_path(current_user), error: 'Die Verknüpfung mit Facebook ist fehlgeschlagen!' }
        format.json { render json: edit_user_path(current_user), status: :unprocessable_entity, location: :overview }
      end
      
    end
  end

  protected

  def oauth
    @oauth ||= Koala::Facebook::OAuth.new(530109983701979, "2b0d3f2f4d7889efe9980a1fffff5211", oauth_callback_default_url)
  end
end
