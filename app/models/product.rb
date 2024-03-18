class Product < ApplicationRecord
  belongs_to :category
  def self.ransackable_attributes(auth_object = nil)
    ["category","category_id", "created_at", "description", "id", "id_value", "name", "price", "stock_quantity", "updated_at", "image_attachment", "image_blob"]
  end

end
