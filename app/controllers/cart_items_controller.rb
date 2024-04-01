# app/controllers/cart_items_controller.rb
class CartItemsController < ApplicationController
  def create
    @cart = current_cart
    return redirect_to root_path, alert: "There was a problem accessing your cart." if @cart.nil?

    product = Product.find(params[:product_id])
    @cart_item = @cart.cart_items.find_or_initialize_by(product_id: product.id)
    @cart_item.quantity = @cart_item.quantity.to_i + 1

    if @cart_item.save
      redirect_to cart_path, notice: 'Product was successfully added to your cart.'

    else
      redirect_to root_path, alert: 'There was a problem adding the product to your cart.'
    end
  end
end
