class CartItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validate :quantity_must_not_exceed_stock

  private

  def quantity_must_not_exceed_stock
    if quantity > product.stock_quantity
      errors.add(:quantity, "exceeds available stock for #{product.name}")
    end
  end
end
