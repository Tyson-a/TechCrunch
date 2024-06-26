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
    @cart_item = CartItem.find_by(id: params[:id])

    if @cart_item.nil?
      flash[:alert] = "CartItem not found."
      redirect_to cart_path
      return
    end

    updated_quantity = cart_item_params[:quantity].to_i

    if updated_quantity > @cart_item.product.stock_quantity
      flash[:alert] = "Only #{@cart_item.product.stock_quantity} of #{@cart_item.product.name} available."
      redirect_to cart_path
      return
    end

    if @cart_item.update(quantity: updated_quantity)
      flash[:notice] = "Cart item updated."
      redirect_to cart_path
    else
      flash[:alert] = "Failed to update cart item."
      redirect_to cart_path
    end
  end



  def destroy
    @cart_item = CartItem.find(params[:id])
    cart = @cart_item.cart
    @cart_item.destroy
    redirect_to cart_path(cart), notice: 'Item was successfully removed from your cart.'
  end

  def update_cart_item(cart, product, quantity)
    cart_item = cart.cart_items.find_or_initialize_by(product_id: product.id)
    cart_item.quantity += quantity
    if cart_item.valid?
      cart_item.save!
      true
    else
      flash[:alert] = cart_item.errors.full_messages.join('. ')
      false
    end
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
