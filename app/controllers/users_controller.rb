# coding: utf-8
require 'pathname'
require "openid"
require 'openid/extensions/sreg'
require 'openid/extensions/pape'
require 'openid/store/filesystem'

class UsersController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create, :activate, :reset_password]
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      if !@user.deleted_at.nil?
        format.html {render action: "user_deleted"}
      else
      format.html # show.html.erb
      format.json { render json: @user }
      end
    end
  end
  
  def snitch
    @user = User.find(params[:id])
    if params[:commit]
      UserMailer.user_snitched(@user, params[:reason], current_user).deliver
      flash[:notice] = "Vielen Dank für die Meldung. Wir kümmern uns darum!"
      redirect_to user_path(@user)
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    if logged_in?
      redirect_to "overview"
    end
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    if @user != current_user
      flash[:error] = "Du kannst nur dich selbst editieren!"
      redirect_to :back
    end
    
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    puts @user
    if @user.openid_url.nil? || @user.openid_url.blank?
      handle_traditional_registration
    else
      handle_openid_registration
    end
  end
  
  def handle_traditional_registration
    respond_to do |format|
      if @user.save
        #session[:user_id] = @user.id
        UserMailer.confirmation_needed(@user).deliver
        format.html { redirect_to :index, notice: 'Die Registrierung war erfolgreich. Du erhälst in Kürze einen Aktivierungslink per E-Mail.' }
        format.json { render json: :index, status: :created, location: :index }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  def handle_openid_registration
    begin
    request = openid_consumer.begin(@user.openid_url)
    rescue OpenID::OpenIDError => e
      flash[:error] = "Der OpenID-Server #{@user.openid_url} war nicht erreichbar."
      redirect_to sign_up_path
     else
     if @user.save
      # Daten anfordern - siehe Spec:
      # http://openid.net/specs/openid-simple-registration-extension-1_0.html
      request.add_extension_arg('sreg','required','email,fullname')
      # Request senden - erster Parameter = Trusted Site,
      # zweiter Parameter = anschließende Weiterleitung
      redirect_to request.redirect_url(root_url, openid_complete_registration_url)
    else 
      respond_to do |format|
     format.html { render action: "new" }
     format.json { render json: @user.errors, status: :unprocessable_entity }
     end
    end
      
    end
  end
  
  
  
  def activate
    @user = User.find_by_activation_token(params[:token])
    respond_to do |format|
    if !@user.nil?
      
      if @user.activate
        session[:user_id] = @user.id
        
        format.html { redirect_to :overview, notice: 'Deine Aktivierung war erfolgreich.' }
        format.json { render json: :overview, status: :created, location: :overview }
      else
        format.html { redirect_to :index, error: 'Etwas ist fehlgeschlagen.' }
        
      end
    end
    end
  end
  
  def reset_password
    @user = User.find_by_email(params[:email])
    if @user.nil?
      flash[:error] = 'Diese E-Mail-Adresse konnte nicht gefunden werden.'
      redirect_to :back
    else
      @user.reset_password
      tmp = @user.password
      if @user.save
        UserMailer.new_password(@user, tmp).deliver
        flash[:notice] = 'Dein Passwort wurde zurückgesetzt. Du erhälst eine E-Mail mit dem neuen Passwort.'
        redirect_to :log_in
      else
        flash[:error] = 'Es ist ein Fehler aufgetreten. Das Passwort konnte nicht zurückgesetzt werden'
        redirect_to :back
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_without_confirmation(params[:user])
        format.html { redirect_to @user, notice: 'Erfolgreich gespeichert!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      session[:user_id] = nil
      @user.destroy
      flash[:notice] = "Dein Account wurde zerstört. Schade, dass du nicht mehr dabei bist."
      redirect_to :index
     end
  end
  
  # Call suicide on user :id in game :game.
  def suicide
    @user = User.find(params[:id])
    if @user == current_user && !@user.current_games.find(:all, :conditions => {:id => params[:game]}).empty?
      @user.suicide_in(params[:game])
      flash[:notice] = "Du bist jetzt tot. Herzlichen Glückwunsch."
      redirect_to :back
    end
  end
  
  protected
    def openid_consumer
    @openid_consumer ||= OpenID::Consumer.new(session, OpenID::Store::Filesystem.new(Rails.root.to_s + "/tmp/openid"))
  end
end
