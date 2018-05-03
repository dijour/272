class CartsController < ApplicationController
  include AppHelpers::Cart
  
  #authorize_resource  
  
  def index
    @cart = session[:cart]
  end
  
  def destroy
    
  end

 def add_to_cart
    # @registration = Registration.new(registration_params)
    @camp = Camp.find(params[:registration][:camp_id])
    @student = Student.find(params[:registration][:student_id])
    add_registration_to_cart(@camp.id, @student.id)
    flash[:notice] = "Successfully added to cart"
    redirect_to @camp 
 end
 
 
end