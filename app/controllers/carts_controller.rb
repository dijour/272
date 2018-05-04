class CartsController < ApplicationController
  include AppHelpers::Cart
  
  #authorize_resource  
  
  def index
    @cart = session[:cart]
    @total_price = calculate_total_cart_registration_cost
    @ids = get_array_of_ids_for_generating_registrations
  end
  
  def create
    @camp_instructor = CampInstructor.new(camp_instructor_params)
    if @camp_instructor.save
      flash[:notice] = "Successfully added instructor."
      redirect_to camp_path(@camp_instructor.camp)
    else
      @camp = Camp.find(params[:camp_instructor][:camp_id])
      @other_instructors = @camp.instructors
      render action: 'new', locals: { camp: @camp, other_instructors: @other_instructors }
    end
  end
 
  def add_to_cart
    # @registration = Registration.new(registration_params)
    @camp = Camp.find(params[:registration][:camp_id])
    @student = Student.find(params[:registration][:student_id])
    add_registration_to_cart(@camp.id, @student.id)
    flash[:notice] = "Successfully added to cart"
    redirect_to @camp 
  end
 
  def delete_from_cart
    @camp = (params[:camp_id].to_i)
    @student = (params[:student_id].to_i)
    remove_registration_from_cart(@camp,@student)
    flash[:notice] = "Deleted item from the cart."
    redirect_to carts_path()
  end
 
  def checkout
    @credit_card_num = params[:credit_card_num]
    @exp_year = params[:expiration_year]
    @exp_month = params[:expiration_month]
    @payment = ""
    cc = CreditCard.new(@credit_card_num, @exp_year, @exp_month)
    if cc.expired?
      flash[:notice] = "Credit card is expired."
      redirect_to carts_path()
    end
    if ! cc.valid?
      flash[:notice] = "Credit card is not valid. Please use AMEX, DCCB, DISC, MC, or VISA"
      redirect_to carts_path()
    end
    for reg in @ids
      r = Registration.new
      r.payment = cc
      r.camp = reg[0]
      r.student = reg[1]
      @payment += r.pay
      r.save
    end
    clear_cart
  end
 
end