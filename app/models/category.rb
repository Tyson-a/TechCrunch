class Category < ApplicationRecord
  has_many :products
  validates :name, presence: true, uniqueness: true
  scope :sellable, -> { where("stock_quantity > ?", 0) }
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "updated_at"]
  end
end
