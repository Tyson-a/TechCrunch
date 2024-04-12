class AddTaxAndTotalWithTaxToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :pst, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :orders, :gst, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :orders, :hst, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :orders, :total_with_tax, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
