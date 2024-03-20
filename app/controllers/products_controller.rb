class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
  end
  def index
    # Initialize the products query based on the filter
    products_query = case params[:filter]
                     when 'on_sale'
                       Product.on_sale
                     when 'new'
                       Product.new_products
                     else
                       Product.all
                     end

    # Apply pagination after the filter has been applied
    @products = products_query.page(params[:page]).per(10)
  end
end
