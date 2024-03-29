class LocationsController < ApplicationController
  authorize_resource  

  before_action :set_location, only: [:show, :edit, :update, :destroy]

  def index
    @active_locations = Location.all.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_locations = Location.all.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    # For sidebar card
    @upcoming_camps_at_location = @location.camps.upcoming.chronological
  end

  def edit
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      redirect_to location_path(@location), notice: "#{@location.name} location was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    respond_to do |format|
      if @location.update_attributes(location_params)
        format.html { redirect_to(@location, :notice => "Successfully updated #{@location.name}.") }
        format.json { respond_with_bip(@location) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@location) }
      end
    end
  end

  def destroy
    @location.destroy
    redirect_to locations_url, notice: "#{@location.name} location was removed from the system."
  end

  private
    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:name, :street_1, :street_2, :city, :state, :zip, :max_capacity, :active)
    end
end