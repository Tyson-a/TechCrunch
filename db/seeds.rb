require 'csv'

# Define your CSV file paths with associated categories
csv_file_paths = {
  'CPUs' => Rails.root.join('lib', 'seeds', 'cpu.csv'),
  'Memory' => Rails.root.join('lib', 'seeds', 'memory.csv'),
  'Monitors' => Rails.root.join('lib', 'seeds', 'monitor.csv'),
  'Motherboards' => Rails.root.join('lib', 'seeds', 'motherboard.csv'),
  'Power Supplies' => Rails.root.join('lib', 'seeds', 'power-supply.csv'),
  'GPUs' => Rails.root.join('lib', 'seeds', 'video-card.csv'),
}

csv_file_paths.each do |category_name, file_path|
  category = Category.find_or_create_by(name: category_name)

  CSV.foreach(file_path, headers: true).with_index do |row, index|
    break if index >= 25 # Stop after processing 25 rows

    Product.create(
      name: row['name'],
      description: row['description'],
      price: row['price'],
      category: category # Here, category is determined by the CSV file
    )
  end
end


# AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
#   admin.password = 'password'
#   admin.password_confirmation = 'password'
# end
