class AddTitleToAboutPages < ActiveRecord::Migration[7.1]
  def change
    add_column :about_pages, :title, :string
  end
end
