# app/models/cart.rb
class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  belongs_to :user, optional: true  # Only if you allow carts without users
end
