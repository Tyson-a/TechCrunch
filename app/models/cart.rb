# app/models/cart.rb
class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  belongs_to :user, optional: true
end
