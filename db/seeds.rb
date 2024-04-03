# require 'csv'

# # Define your CSV file paths with associated categories
# csv_file_paths = {
#   'CPUs' => Rails.root.join('lib', 'seeds', 'cpu.csv'),
#   'Memory' => Rails.root.join('lib', 'seeds', 'memory.csv'),
#   'Monitors' => Rails.root.join('lib', 'seeds', 'monitor.csv'),
#   'Motherboards' => Rails.root.join('lib', 'seeds', 'motherboard.csv'),
#   'Power Supplies' => Rails.root.join('lib', 'seeds', 'power-supply.csv'), # Fixed typo
#   'GPUs' => Rails.root.join('lib', 'seeds', 'video-card.csv'),
# }

# csv_file_paths.each do |category_name, file_path|
#   category = Category.find_or_create_by(name: category_name)

#   CSV.foreach(file_path, headers: true) do |row|
#     Product.create(
#       name: row['name'],
#       description: row['description'],
#       price: row['price'],
#       category: category # Here, category is determined by the CSV file
#     )
#   end
# end

# AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
#   admin.password = 'password'
#   admin.password_confirmation = 'password'
# end

# provinces = [
#   { name: "Alberta", gst: 5, pst: 0, hst: 0 },
#   { name: "British Columbia", gst: 5, pst: 7, hst: 0 },
#   { name: "Manitoba", gst: 5, pst: 7, hst: 0 },
#   { name: "Newfoundland and Labrador", gst: 0, pst: 0, hst: 15 },
#   { name: "Northwest Territories", gst: 5, pst: 0, hst: 0 },
#   { name: "Nova Scotia", gst: 0, pst: 0, hst: 15 },
#   { name: "Nunavut", gst: 5, pst: 0, hst: 0 },
#   { name: "Ontario", gst: 0, pst: 0, hst: 13 },
#   { name: "Prince Edward Island", gst: 0, pst: 0, hst: 15 },
#   { name: "Quebec", gst: 5, pst: 9.975, hst: 0 },
#   { name: "Yukon", gst: 5, pst: 0, hst: 0 },
#   { name: "Saskatchewan", gst: 5, pst: 6, hst: 0 },


# ]

# provinces.each do |province|
#   Province.find_or_create_by(name: province[:name]) do |p|
#     p.gst = province[:gst]
#     p.pst = province[:pst]
#     p.hst = province[:hst]
#   end
# end

require 'csv'

csv_file_path = Rails.root.join('lib', 'seeds', 'products_images.csv')

retry_count = 10
max_retries = 100

begin
  CSV.foreach(csv_file_path, headers: true) do |row|
    description = row['Description']
    if description.include?(' - ') # Check if description includes ' - '
      name = description.split(' - ').first.strip # Extract name from the beginning of description
      if row['Name'].nil? || row['Name'].empty? # Check if 'Name' column is empty
        row['Name'] = name # Assign extracted name to 'Name' column
      end
    end

    if row['Name'] # Ensure there is a value for 'Name'
      name = row['Name'].strip
      product = Product.find_by(name: name)
      if product
        product.update(description: description&.strip) # Update description
        image_path = row['Image Path']&.strip
        if image_path.present? # Check if image path is present
          # Attach image to product
          product.images.attach(io: File.open(image_path), filename: File.basename(image_path))
        end
        puts "Updated: #{product.name}"
      else
        puts "Product not found for name: #{name}"
      end
    else
      puts "Name column value missing in row: #{row.inspect}"
    end
  end
rescue SQLite3::BusyException
  retry_count += 1
  if retry_count <= max_retries
    sleep 1
    retry
  else
    puts "Maximum retry attempts reached. Aborting..."
  end
end
