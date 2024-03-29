class InstructorsController < ApplicationController
  authorize_resource  

  before_action :set_instructor, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :index, @instructors
    @instructors = Instructor.all.alphabetical.paginate(:page => params[:page]).per_page(12)
  end

  def show
    authorize! :show, @instructor
    @past_camps = @instructor.camps.past.chronological
    @upcoming_camps = @instructor.camps.upcoming.chronological
  end

  def edit
    authorize! :update, @instructor
  end

  def new
    @instructor = Instructor.new
  end

  def create
    @instructor = Instructor.new(instructor_params)
    @user = User.new(user_params)
    @user.role = "instructor"

    if !@user.save
      @instructor.valid?
      render action: 'new'
    else
      @instructor.user_id = @user.id
      if @instructor.save
        flash[:notice] = "Successfully created #{@instructor.proper_name}."
        redirect_to instructor_path(@instructor) 
      else
        render action: 'new'
      end      
    end
  end
  
  def update
    respond_to do |format|
      if @instructor.update_attributes(instructor_params)
        format.html { redirect_to(@instructor, :notice => "Successfully updated #{@instructor.proper_name}.") }
        format.json { respond_with_bip(@instructor) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@instructor) }
      end
    end
  end

  def destroy
    @instructor.destroy
    redirect_to instructors_url, notice: "#{@instructor.first_name} #{@instructor.last_name} was deleted from the system."
  end

  def change_pass
    @instructor = Instructor.find(params[:id]) 
  end

  def change_photo
    @instructor = Instructor.find(params[:id]) 
  end
  

  private
    def set_instructor
      @instructor = Instructor.find(params[:id])
    end

    def instructor_params
      params.require(:instructor).permit(:first_name, :last_name, :photo, :bio, :username, :active, :email, :phone, :password, :password_confirmation)
    end
    
    def user_params
      params.require(:instructor).permit(:username, :email, :phone, :role, :password, :password_confirmation, :active)
    end

end