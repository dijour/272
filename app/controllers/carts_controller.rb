class CartsController < ApplicationController
  include AppHelpers::Cart
  
  #authorize_resource  
  
  def index
    @cart = session[:cart]
    @total_price = calculate_total_cart_registration_cost
    @ids = get_array_of_ids_for_generating_registrations
  end
  
  def destroy(camp_id, student_id)
    remove_registration_from_cart(camp_id, student_id)
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