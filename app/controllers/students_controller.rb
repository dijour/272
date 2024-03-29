class StudentsController < ApplicationController
  authorize_resource  


  before_action :set_student, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :index, @students
    @students = Student.all.alphabetical.paginate(:page => params[:students]).per_page(12)
  end

  def show
    authorize! :show, @student
    @all_registrations = @student.registrations
    @upcoming_camps = []
    @past_camps = []
    for reg in @all_registrations
      if Camp.upcoming.include? reg.camp
        @upcoming_camps << reg.camp
      else
        @past_camps << reg.camp
      end
    end
  end

  def edit
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      redirect_to student_path(@student), notice: "#{@student.first_name} #{@student.last_name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    respond_to do |format|
      if @student.update_attributes(student_params)
        format.html { redirect_to(@student, :notice => "Successfully updated #{@student.proper_name}.") }
        format.json { respond_with_bip(@student) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@student) }
      end
    end
  end

  def destroy
    @student.destroy
    redirect_to students_url, notice: "#{@student.first_name} #{@student.last_name}was deleted from the system."
  end

  private
    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:first_name, :last_name, :date_of_birth, :rating, :family_id, :active)
    end
end