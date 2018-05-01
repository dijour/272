class CartsController < ApplicationController
  include AppHelpers::Cart
  
  # authorize_resource  
  
  def index
    @cart = session[:cart]
  end
  

end