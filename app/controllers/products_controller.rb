class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
  end
  def index
    @products = Product.page(params[:page]).per(10) # Example: limit to 20 for the front page, adjust as needed
  end
end
