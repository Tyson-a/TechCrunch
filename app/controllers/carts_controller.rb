class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :add_item, :checkout]

  def show
    @cart
  end

  def add_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    # Validate quantity
    if quantity <= 0
      flash[:alert] = "Invalid quantity."
      redirect_to products_path and return
    end

    # Check stock availability
    if product.stock_quantity < quantity
      flash[:alert] = "Only #{product.stock_quantity} of #{product.name} available."
      redirect_to products_path and return
    end

    begin
      Product.transaction do
        product.lock!

        # Verify we can add items without exceeding stock
        if can_update_cart_item?(@cart, product, quantity)
          update_cart_item(@cart, product, quantity)
          product.update!(stock_quantity: product.stock_quantity - quantity) # Deduct from stock
          flash[:notice] = "#{product.name} added to cart."
        else
          flash[:alert] = "Could not add #{quantity} of #{product.name} to the cart."
          redirect_to products_path and return
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      flash[:alert] = "Failed to add #{product.name} to cart. Error: #{e.message}"
      redirect_to products_path and return
    end

    redirect_to products_path
  end

  def checkout
    ActiveRecord::Base.transaction do
      order = current_user.orders.create!(order_params) # Create an order

      @cart.cart_items.each do |cart_item|
        order.order_items.create!(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          unit_price: cart_item.product.price # Assuming price is stored in the Product model
        )
      end

      @cart.cart_items.destroy_all # Clear the cart after checkout
      redirect_to order_path(order), notice: 'Checkout successful.'
    rescue ActiveRecord::RecordInvalid => e
      redirect_to cart_path, alert: "Failed to create order: #{e.message}"
    end
  end


  def set_cart
    @cart = current_cart # Ensure this method correctly finds or initializes the current user's cart
  end

  def can_update_cart_item?(cart, product, quantity)
    cart_item = cart.cart_items.find_by(product_id: product.id)
    new_quantity = cart_item ? cart_item.quantity + quantity : quantity
    new_quantity <= product.stock_quantity
  end

  def update_cart_item(cart, product, quantity)
    cart_item = cart.cart_items.find_or_initialize_by(product_id: product.id)
    cart_item.quantity += quantity
    cart_item.save!
  end
end
