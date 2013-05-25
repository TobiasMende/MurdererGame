# coding: utf-8
class OauthController < ApplicationController
  def init_default
    redirect_to oauth(oauth_callback_default_url).url_for_oauth_code(:permissions => "publish_stream")
  end

  def callback_default
    info = oauth(oauth_callback_default_url).get_access_token_info(params[:code], :permissions => "publish_stream")
    token = info["access_token"]
        
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
          current_user.facebook_access_token = token
          current_user.facebook_oauth_expires_at = DateTime.now + info["expires"].to_i.seconds
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

end
