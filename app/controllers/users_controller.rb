class UsersController < ApplicationController
  authorize_resource  

  #before_action :check_login
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users/new
  def new
    @user = User.new
  end
  
  def index
    @users = User.all
  end

  # GET /users/1/edit
  def edit
    authorize! :updet, @user
    @user = :current_user
  end


  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to(home_path, :notice => 'User was successfully created.')
    else
      render :action => "new"
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update_attributes(current_user)
      redirect_to(@user, :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    redirect_to(home_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :phone, :role, :password, :password_confirmation, :active)
    end
end