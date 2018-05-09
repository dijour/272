class CampsController < ApplicationController
  #authorize_resource  

  before_action :set_camp, only: [:show, :edit, :update, :destroy, :instructors, :students]

  def index
    @active_camps = Camp.all.active.paginate(:page => params[:active_camps]).per_page(10)
    @inactive_camps = Camp.all.inactive.alphabetical.paginate(:page => params[:inactive_camps]).per_page(10)
  end

  def show
    @instructors = @camp.instructors.alphabetical
    @students = @camp.students.alphabetical
    @registrations = @camp.registrations.alphabetical
  end

  def edit
  end

  def new
    @camp = Camp.new
  end

  def create
    @camp = Camp.new(camp_params)
    if @camp.save
      redirect_to camp_path(@camp), notice: "#{@camp.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    respond_to do |format|
      if @camp.update_attributes(camp_params)
        format.html { redirect_to(@camp, :notice => "Successfully updated #{@camp.name}.") }
        format.json { respond_with_bip(@camp) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@camp) }
      end
    end
  end

  def destroy
    @camp.destroy
    redirect_to camps_url, notice: "#{@camp.name} was removed from the system."
  end
  
  def instructors
    @instructors = @camp.instructors.alphabetical
  end
  
  def students
    @students = @camp.students.alphabetical
  end

  private
    def set_camp
      @camp = Camp.find(params[:id])
    end

    def camp_params
      params.require(:camp).permit(:curriculum_id, :location_id, :cost, :start_date, :end_date, :time_slot, :max_students, :active)
    end
end