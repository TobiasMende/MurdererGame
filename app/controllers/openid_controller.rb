# coding: utf-8
require 'pathname'
require 'user'
require "openid"
require 'openid/extensions/sreg'
require 'openid/extensions/pape'
require 'openid/store/filesystem'

class OpenidController < ApplicationController
    skip_before_filter :require_login
  def login
  end

  def begin
    openid = params[:openid_url]
    if openid.nil?
        flash[:error] = "Bitte gib eine OpenID-URL ein."
        redirect_to :back
        return
      end
     begin
    request = openid_consumer.begin(openid)
    rescue OpenID::OpenIDError => e
      flash[:error] = "Der OpenID-Server #{openid} war nicht erreichbar."
      redirect_to :back
    else
      # Daten anfordern - siehe Spec:
      # http://openid.net/specs/openid-simple-registration-extension-1_0.html
      request.add_extension_arg('sreg','required','email,fullname')
      #request.add_extension_arg('sreg','optional','nickname')
      # Request senden - erster Parameter = Trusted Site,
      # zweiter Parameter = anschließende Weiterleitung
      redirect_to request.redirect_url(root_url, openid_complete_url)
    end
  end
  
  def complete_registration
    params.delete("controller")
    params.delete("action")
    response = openid_consumer.complete(params, openid_complete_registration_url)
    openid = response.identity_url
       respond_to do |format|
         puts "MESSAGE: "+response.message.to_s
     user = User.find_by_openid_url(openid).first
    if response.status == OpenID::Consumer::SUCCESS
      email = params["openid.sreg.email"]
      fullname = params["openid.sreg.fullname"]
     if !user.nil?
       user.email= email
      if user.save
        UserMailer.confirmation_needed(user).deliver
        format.html { redirect_to :index, notice: 'Die Registrierung war erfolgreich. Du erhälst in Kürze einen Aktivierungslink per E-Mail.' }
        format.json { render json: :index, status: :created, location: :index }
      else
        format.html { redirect_to sign_up_path }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
     else
       format.html { redirect_to sign_up_path }
        format.json { render json: user.errors, status: :unprocessable_entity }
     end
     elsif !user.nil?
       user.delete
       format.html { redirect_to sign_up_path, error: "Registrierung mit OpenID fehlgeschlagen. Versuch es nocheinmal."}
     else
       
    format.html {redirect_to sign_up_path, error: "Registrierung fehlgeschlagen. Bitte frag einen Admin."}
    end
      end
  end
  
  def complete
    params.delete("controller")
    params.delete("action")
    response = openid_consumer.complete(params, openid_complete_url)
    openid = response.identity_url
    if response.status == OpenID::Consumer::SUCCESS
      email = params["openid.sreg.email"]
      fullname = params["openid.sreg.fullname"]
     user = User.find_by_openid_url(openid).first
     if !user.nil?
       session[:user_id] = user.id
       user.update_column("last_login", DateTime.now)
      flash[:notice] = "Eingeloggt!"
      redirect_to :overview
      else
        flash[:error] = "Der OpenID-Login ist fehlgeschlagen."
    redirect_to openid_login_path
     end
    else
      flash[:error] = "Das Login mit der OpenID #{openid} war nicht erfolgreich."
      redirect_to openid_login_path
    end
  end

protected
  def openid_consumer
    @openid_consumer ||= OpenID::Consumer.new(session, OpenID::Store::Filesystem.new(Rails.root.to_s + "/tmp/openid"))
  end
end
