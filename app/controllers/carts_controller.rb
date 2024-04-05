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
      # Implement checkout logic here
      flash[:notice] = "Checkout successful."
      redirect_to some_successful_checkout_path
    else
      flash[:alert] = "Insufficient stock for: #{insufficient_stock_items.join(', ')}."
      redirect_to cart_path
    end
  end

  private

  def quantity_must_not_exceed_stock
    return unless product && quantity

    if quantity > product.stock_quantity
      errors.add(:quantity, "exceeds available stock for #{product.name}")
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
