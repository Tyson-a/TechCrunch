class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :stock_quantity
      t.boolean :on_sale
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
