class Product < ApplicationRecord
  belongs_to :category
  has_many_attached :images
  has_many :cart_items
  before_save :validate_stock_quantity

  scope :sellable, -> { where("stock_quantity > ?", 0) }
  scope :on_sale, -> { where(on_sale: true) }
  scope :new_products, -> { where('created_at >= ?', 3.days.ago) }

  def image
    images.first
  end


  def update_quantity(amount)
    new_quantity = stock_quantity + amount
    if new_quantity >= 0
      self.stock_quantity = new_quantity
      save
    else
      errors.add(:stock_quantity, "Insufficient stock. Cannot reduce by #{amount.abs}.")
      false
    end
  end

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

  private

  # Validation callback to ensure stock quantity integrity
  def validate_stock_quantity
    if stock_quantity_changed? && stock_quantity < 0
      errors.add(:stock_quantity, "cannot be less than zero")
      throw :abort
    end
  end
end
