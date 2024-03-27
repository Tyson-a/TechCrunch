class Product < ApplicationRecord

  def image
    images.first
  end
  belongs_to :category
  has_many_attached :images
   # Assuming you have `description` as a field and an `image` as an attached file (e.g., using Active Storage)
   validates :description, presence: true

   validates :image, presence: true

   # Custom method to check if a product is sellable
   def sellable?
    description.present? && images.attached?
  end
  def self.ransackable_associations(auth_object = nil)
    ['category'] # Ensures the category association is searchable
  end
  def self.ransackable_attributes(auth_object = nil)
    ["name", "description", "price", "stock_quantity", "created_at", "updated_at", "category_id"] # example attributes
  end
  scope :on_sale, -> { where(on_sale: true) }
  scope :new_products, -> { where('created_at >= ?', 3.days.ago) }
end
