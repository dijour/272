class CartsController < ApplicationController
  include AppHelpers::Cart
  require 'base64'
  
  skip_before_action :verify_authenticity_token  

  
  #authorize_resource  
  
  def index
    @cart = session[:cart]
    @total_price = calculate_total_cart_registration_cost
    @ids = get_array_of_ids_for_generating_registrations
    @payment = set_up_payments
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
    @payment = Array.new
    @credit_card_num = params[:number].to_s.gsub(/\s+/, "")
    @exp_year = params[:expiry].chomp(" ").split("/")[1].gsub(/\s+/, "").to_i
    @exp_month = params[:expiry].chomp(" ").split("/")[0].gsub(/\s+/, "").to_i
    cc = CreditCard.new(@credit_card_num, @exp_year, @exp_month)
    if cc.expired? && (!cc.valid?)
      flash[:notice] = "Credit card and expiration date are invalid."
      redirect_to carts_path()
      return
    end
    if cc.expired?
      flash[:notice] = "Credit card is expired."
      redirect_to carts_path()
      return
    end
    if !cc.valid?
      flash[:notice] = "Credit card is not valid. Please use AMEX, DCCB, DISC, MC, or VISA"
      redirect_to carts_path()
      return
    end
    if cc.valid? && ! cc.expired?
      for reg in get_array_of_ids_for_generating_registrations
        r = Registration.new
        r.camp_id = reg[0]
        r.student_id = reg[1]
        r.credit_card_number= @credit_card_num
        r.expiration_year = @exp_year
        r.expiration_month = @exp_month
        r.pay
        blah = Base64.decode64(r.payment)
        a = blah.gsub!(/[\:\;\.]/, '')
        b = []
        b << a
        @payment << b
      end
      clear_cart
      flash[:notice] = "Thank you for your purchase!"
      # redirect_to carts_path()
      redirect_to receipt_path(@payment)
    end
  end
  
  def receipt
    @payment = params[:payment]
  end
    
  def set_up_payments
    @payments = []
  end
 
end