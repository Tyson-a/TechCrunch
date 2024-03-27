class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
  end

  def index
    # Start with the base query
    products_query = case params[:filter]
                     when 'on_sale'
                       Product.on_sale
                     when 'new'
                       Product.new_products
                     else
                       Product.all
                     end

    # Filter by keyword if it's provided
    if params[:keyword].present?
      products_query = products_query.where("name LIKE :keyword OR description LIKE :keyword", keyword: "%#{params[:keyword]}%")
    end


    # Filter by category if a category_id is provided and it's not blank
    if params[:category_id].present?
      products_query = products_query.where(category_id: params[:category_id])
    end

    # Continue applying pagination to the filtered query
    @products = products_query.page(params[:page]).per(10)
  end
end
