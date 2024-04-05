# app/models/cart.rb
class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  belongs_to :user, optional: true

  validate :quantity_must_not_exceed_stock

  private

  def quantity_must_not_exceed_stock
    if quantity.present? && product_id.present? && quantity > product.stock_quantity
      errors.add(:quantity, "exceeds available stock for #{product.name}")
    end
  end
end
