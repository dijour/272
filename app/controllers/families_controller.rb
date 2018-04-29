class FamiliesController < ApplicationController
  authorize_resource  


  before_action :set_family, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :index, @families
    @families = Family.all.alphabetical.paginate(:page => params[:page]).per_page(12)
  end

  def show
    authorize! :show, @family
    @students = @family.students.alphabetical
  end

  def edit
  end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)
    @user = User.new(user_params)
    @user.role = "parent"

    if !@user.save
      @family.valid?
      render action: 'new'
    else
      @family.user_id = @user.id
      if @family.save
        flash[:notice] = "Successfully created #{@family.family_name}."
        redirect_to family_path(@family) 
      else
        render action: 'new'
      end      
    end
  end

  def update
    if @family.update(family_params)
      redirect_to family_path(@family), notice: "The #{@family.family_name} family was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @family.destroy
    redirect_to families_url, notice: "The #{@family.family_name} family was deleted from the system."
  end

  private
    def set_family
      @family = Family.find(params[:id])
    end

    def family_params
      params.require(:family).permit(:family_name, :parent_first_name, :active, :username, :email, :phone, :password, :password_confirmation)
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:family).permit(:username, :email, :phone, :role, :password, :password_confirmation, :active)
    end

end