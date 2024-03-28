# app/controllers/cart_items_controller.rb
class CartItemsController < ApplicationController
  def create
    @cart = current_cart
    @cart_item = @cart.cart_items.find_by(product_id: params[:product_id])

    if @cart_item
      @cart_item.quantity += 1
    else
      @cart_item = @cart.cart_items.new(product_id: params[:product_id], quantity: 1)
    end

    if @cart_item.save
      redirect_to cart_path, notice: 'Product added to cart.'
    else
      redirect_to root_path, alert: 'Unable to add product to cart.'
    end
  end
end
