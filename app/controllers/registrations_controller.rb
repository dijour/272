class RegistrationsController < ApplicationController
  
  authorize_resource  

  
  def new
    @registration   = Registration.new
    @camp           = Camp.find(params[:camp_id])
    @other_students = @camp.students
  end
  
  def create
    @registration = Registration.new(registration_params)
    if @registration.save
      flash[:notice] = "Successfully added registration."
      redirect_to camp_path(@registration.camp)
    else
      @camp = Camp.find(params[:registration][:camp_id])
      @other_students = @camp.students
      render action: 'new', locals: { camp: @camp, other_students: @other_students }
    end
  end
 
  def destroy
    @registration = Registration.find(params[:id])
    @registration.destroy
    flash[:notice] = "Successfully removed this instructor."
    redirect_to camp_path(@registration.camp)
  end

  private
    def registration_params
      params.require(:registration).permit(:camp_id, :student_id)
    end

end