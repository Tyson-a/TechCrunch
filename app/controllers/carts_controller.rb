class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :add_item]

  def show
    @cart
  end

  def add_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    if quantity <= 0
      flash[:alert] = "Invalid quantity."
      redirect_to products_path and return
    end

    if product.stock_quantity < quantity
      flash[:alert] = "Only #{product.stock_quantity} of #{product.name} available."
      redirect_to products_path and return
    end

    begin
      Product.transaction do
        product.lock!
        if update_cart_item(product, quantity)
          # Adjust product stock_quantity here if necessary
          product.update!(stock_quantity: product.stock_quantity - quantity)
          flash[:notice] = "#{product.name} added to cart."
        else
          flash[:alert] = "Could not add #{quantity} of #{product.name} to the cart."
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      flash[:alert] = "Failed to add #{product.name} to cart. Error: #{e.message}"
    end

    redirect_to products_path
  end

  def checkout
    cart_items = current_cart.cart_items
    insufficient_stock_items = []

    cart_items.each do |item|
      unless item.product.stock_quantity >= item.quantity
        insufficient_stock_items << item.product.name
      end
    end

    if insufficient_stock_items.empty?
      
    else
      flash[:alert] = "Insufficient stock for: #{insufficient_stock_items.join(', ')}."
      redirect_to cart_path
    end
  end


  private

  def set_cart
    @cart = current_cart
  end

  def update_cart_item(product, quantity)
    cart_item = @cart.cart_items.find_by(product_id: product.id)

    if cart_item
      cart_item.update!(quantity: cart_item.quantity + quantity)
    else
      @cart.cart_items.create!(product: product, quantity: quantity)
    end
  end
end
