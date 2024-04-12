# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show]

  def show
    @order = current_user.orders.find(params[:id])
    # Add any additional setup here for the view, such as tax calculations
  end


  def create
    @order = Order.new(order_params)
    @order.user = current_user
    @order.status = 'pending'
    # Add logic to transfer items from cart to order, calculate totals, etc.
    if @order.save
      session[:cart_id] = nil # Clear the cart session if you're using it
      redirect_to order_path(@order), notice: 'Thank you for your order.'
    else
      render :new
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def set_cart
  @cart = current_user.cart
  unless @cart.present? && @cart.cart_items.any?
    redirect_to root_url, notice: 'Your cart is empty.' # Change to a path that exists, e.g., root_url
  end
end

def order_params
  params.require(:order).permit(:shipping_address, :payment_method) # Ensure 'shipping_address' is allowed
end

end
