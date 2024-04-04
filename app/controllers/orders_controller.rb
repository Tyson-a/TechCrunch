# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def new
    # Initialize your order object here, possibly with shipping info if available
    @order = Order.new
  end

  

  def create
    @order = Order.new(order_params)
    @order.user = current_user
    @order.status = 'pending'
    # Add logic to transfer items from cart to order, calculate totals, etc.
    if @order.save
      # Handle payment processing here if necessary
      redirect_to @order, notice: 'Thank you for your order.'
    else
      render :new
    end
  end

  private

  def set_cart
    @cart = current_user.cart
    redirect_to store_index_url, notice: 'Your cart is empty.' unless @cart.present? && @cart.cart_items.any?
  end

  def order_params
    params.require(:order).permit(:shipping_address, :payment_method)
  end
end
