class CurriculumsController < ApplicationController
  authorize_resource  

  before_action :set_curriculum, only: [:show, :edit, :update, :destroy]

  def index
    @curriculums = Curriculum.all.alphabetical
  end

  def show
    @past_camps_using = @curriculum.camps.past.chronological
    @upcoming_camps_using = @curriculum.camps.upcoming.chronological
  end

  def edit
  end

  def new
    @curriculum = Curriculum.new
  end

  def create
    @curriculum = Curriculum.new(curriculum_params)
    if @curriculum.save
      redirect_to curriculum_path(@curriculum), notice: "#{@curriculum.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    respond_to do |format|
      if @curriculum.update_attributes(curriculum_params)
        format.html { redirect_to(@curriculum, :notice => "Successfully updated #{@curriculum.name}.") }
        format.json { respond_with_bip(@curriculum) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@curriculum) }
      end
    end
  end

  def destroy
    @curriculum.destroy
    redirect_to curriculums_url, notice: "#{@curriculum.name} was removed from the system."
  end

  private
    def set_curriculum
      @curriculum = Curriculum.find(params[:id])
    end

    def curriculum_params
      params.require(:curriculum).permit(:name, :description, :min_rating, :max_rating, :active)
    end
end