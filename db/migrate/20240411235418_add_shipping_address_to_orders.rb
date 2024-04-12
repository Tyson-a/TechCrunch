class AddShippingAddressToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :shipping_address, :string
  end
end
