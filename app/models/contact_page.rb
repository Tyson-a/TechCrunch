class ContactPage < ApplicationRecord
  # If there are any other model configurations or validations, they go here

  # Define which attributes can be searched
  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "title", "updated_at"]
    # Ensure this list includes the attributes you want searchable and excludes sensitive information
  end
end
