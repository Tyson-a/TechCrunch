# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  helper_method :current_cart
  before_action :configure_permitted_parameters, if: :devise_controller?



  def current_cart
    if session[:cart_id]
      Cart.find(session[:cart_id])
    else
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:street, :city, :province_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:street, :city, :province_id])
  end
end
