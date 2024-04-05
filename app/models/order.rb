class Order < ApplicationRecord
  belongs_to :user

  def self.ransackable_associations(auth_object = nil)
    %w[user] # Only allow 'user' for now. Add more associations as needed.
  end

  def self.ransackable_attributes(auth_object = nil)
    # List of attributes you want to be searchable
    %w[id created_at updated_at status] # Add more attributes as needed
  end
end
