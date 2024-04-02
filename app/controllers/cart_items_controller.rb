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
  def update
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to cart_path(@cart_item.cart), notice: 'Quantity was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @cart_item = CartItem.find(params[:id])
    cart = @cart_item.cart
    @cart_item.destroy
    redirect_to cart_path(cart), notice: 'Item was successfully removed from your cart.'
  end


  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end

end
