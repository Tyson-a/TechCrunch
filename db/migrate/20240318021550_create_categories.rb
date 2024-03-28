class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name  # This line should be inside the block
      t.text :description  # You can directly add columns here
      t.timestamps
    end
  end
end
