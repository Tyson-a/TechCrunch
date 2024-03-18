class AddTitleToContactPage < ActiveRecord::Migration[7.1]
  def change
    add_column :contact_pages, :title, :string
  end
end
