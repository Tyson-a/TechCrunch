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
    cart_items = @cart.cart_items
    insufficient_stock_items = []

    cart_items.each do |item|
      unless item.product.stock_quantity >= item.quantity
        insufficient_stock_items << item.product.name
      end
    end

    if insufficient_stock_items.empty?
      # Proceed with order creation if stock is sufficient
      order = current_user.orders.create(status: 'pending', shipping_address: "Some address") # Example, adjust as needed

      cart_items.each do |cart_item|
        # Here you'd transfer cart items to order items, adjust according to your app's models
        order.order_items.create(product: cart_item.product, quantity: cart_item.quantity) # This is an example, adjust accordingly
      end

      # Optionally clear the cart after successful order placement
      @cart.cart_items.destroy_all

      redirect_to order_path(order), notice: 'Checkout successful.'
    else
      flash[:alert] = "Insufficient stock for: #{insufficient_stock_items.join(', ')}."
      redirect_to cart_path
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
