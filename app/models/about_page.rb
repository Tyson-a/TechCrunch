# app/models/about_page.rb
class AboutPage < ApplicationRecord
  # Your existing model code...

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "title", "updated_at"]
    # Adjust the array to include only the attributes you want to be searchable.
  end
end
