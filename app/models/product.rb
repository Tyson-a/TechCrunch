class Product < ApplicationRecord
  # Associations
  belongs_to :category
  has_many_attached :images
  has_many :cart_items
  has_many :carts, through: :cart_items

  # Callbacks
  before_save :validate_stock_quantity

  # Scopes
  scope :sellable, -> { where("stock_quantity > ?", 0) }
  scope :on_sale, -> { where(on_sale: true) }
  scope :new_products, -> { where('created_at >= ?', 3.days.ago) }

  # Instance methods

  # Returns the first attached image of a product
  def image
    images.first
  end

  # Updates the stock quantity of a product
  def update_quantity(amount)
    new_quantity = stock_quantity + amount

    # Validation checks
    if new_quantity < 0
      errors.add(:stock_quantity, "cannot reduce below 0.")
      return false
    elsif new_quantity > self.stock_limit
      errors.add(:stock_quantity, "exceeds the stock limit of #{self.stock_limit}.")
      return false
    end

    # Update stock quantity if validations pass
    self.stock_quantity = new_quantity
    save
  end

  # Checks if a product is sellable based on certain conditions
  def sellable?
    description.present? && images.attached?
  end

  # Class methods

  # Defines associations that can be searched through Ransack
  def self.ransackable_associations(auth_object = nil)
    ["cart_items", "category", "images_attachments", "images_blobs"]
  end

  # Defines attributes that can be searched through Ransack
  def self.ransackable_attributes(auth_object = nil)
    ["name", "description", "price", "stock_quantity", "created_at", "updated_at", "category_id"] # Example attributes
  end

  private

  # Validates stock quantity to ensure it's not below zero
  def validate_stock_quantity
    if stock_quantity_changed? && stock_quantity < 0
      errors.add(:stock_quantity, "cannot be less than zero")
      throw :abort
    end
  end
end
