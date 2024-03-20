class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = @category.products.page(params[:page]).per(10) # Adjust the number per page as needed
  end

  def index
    @categories = Category.page(params[:page]).per(10) # Adjust the number per page as needed
  end
end
