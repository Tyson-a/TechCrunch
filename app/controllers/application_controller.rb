# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  helper_method :current_cart
  before_action :configure_permitted_parameters, if: :devise_controller?


  def current_cart
    Rails.logger.debug "User signed in: #{user_signed_in?}"

    if user_signed_in?
      cart = Cart.find_or_create_by(user_id: current_user.id)
      session[:cart_id] = cart.id
      Rails.logger.debug "Cart for signed-in user: #{cart.inspect}"
    else
      cart = Cart.find_by(id: session[:cart_id])
      if cart.nil?
        cart = Cart.create
        session[:cart_id] = cart.id
      end
      Rails.logger.debug "Cart for guest: #{cart.inspect}"
    end

    cart
  rescue => e
    Rails.logger.error "Error in current_cart: #{e.message}"
    nil
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :address, :city, :province_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :current_password, :address, :city, :province_id])
  end
end
