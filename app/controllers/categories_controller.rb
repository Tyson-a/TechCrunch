class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])

    @products = @category.products.sellable.page(params[:page]).per(10)
  end

  def index
    @categories = Category.page(params[:page]).per(10)
  end
end
