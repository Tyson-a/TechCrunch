class ProductsController < ApplicationController


  def show
    @product = Product.find(params[:id])

  end

  def index
    # Your existing filter logic remains the same
    products_query = case params[:filter]
                     when 'on_sale'
                       Product.on_sale
                     when 'new'
                       Product.new_products
                     else
                       Product.all
                     end

    if params[:keyword].present?
      keyword = params[:keyword].downcase
      products_query = products_query.where('LOWER(name) LIKE ? OR LOWER(description) LIKE ?', "%#{keyword}%", "%#{keyword}%")
    end

    if params[:category_id].present?
      products_query = products_query.where(category_id: params[:category_id])
    end

    # Fetch products based on filters and check for sellability in Ruby
    products_query = products_query.sellable

    # Apply Kaminari pagination to the array of sellable products
    @products = products_query.page(params[:page]).per(10)
  end

end
