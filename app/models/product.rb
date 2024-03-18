class Product < ApplicationRecord
  belongs_to :category
  has_many_attached :images
  def self.ransackable_associations(auth_object = nil)
    ['category'] # Ensures the category association is searchable
  end
  def self.ransackable_attributes(auth_object = nil)
    ["name", "description", "price", "stock_quantity", "created_at", "updated_at", "category_id"] # example attributes
  end
end
