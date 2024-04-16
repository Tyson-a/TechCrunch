class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  def update_status(new_status)
    update(status: new_status)
  end

    # Calculate the total price before taxes
    # Calculate the total price before taxes
    def total_before_tax
      order_items.sum { |item| item.quantity * item.unit_price }
    end

    # Calculate the total price before taxes
  def total_before_tax
    order_items.sum { |item| item.quantity * item.unit_price }
  end

  # Calculate tax amount based on user's province
  def tax_amount
    subtotal = total_before_tax
    pst = subtotal * (user.province.pst || 0) / 100
    gst = subtotal * (user.province.gst || 0) / 100
    hst = subtotal * (user.province.hst || 0) / 100

    pst + gst + hst
  end

  # Calculate total price including taxes without needing an argument
  def total_with_tax
    subtotal = total_before_tax
    self.tax_total = tax_amount
    subtotal + tax_total
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user] # Only allow 'user' for now. Add more associations as needed.
  end

  def self.ransackable_attributes(auth_object = nil)
    # Add 'shipping_address' to the list of searchable attributes
    %w[id created_at updated_at status shipping_address] # Assuming 'shipping_address' is the correct column name
  end
end
