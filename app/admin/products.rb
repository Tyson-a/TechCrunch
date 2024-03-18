ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :category_id
end
