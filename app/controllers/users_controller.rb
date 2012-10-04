#encoding: utf-8
class UsersController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create]
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

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to :overview, notice: 'Die Registrierung war erfolgreich.' }
        format.json { render json: :overview, status: :created, location: :overview }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
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
      redirect_to :index, notice: "Dein Account wurde zerstört. Schade, dass du nicht mehr dabei bist."
     end
    
  end
  
  
end
