ActiveAdmin.register Product do
  # Add :on_sale to the list of permitted parameters
  permit_params :name, :description, :price, :stock_quantity, :category_id, :on_sale, images: []

  filter :category_id, as: :select, collection: -> { Category.all.map { |c| [c.name, c.id] } }

  form do |f|
    f.semantic_errors # Handles displaying errors
    f.inputs 'Product Details' do
      # Your other product inputs
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category_id, as: :select, collection: Category.all.collect { |c| [c.name, c.id] }
      f.input :on_sale, as: :boolean # Add this line
      f.input :images, as: :file, input_html: { multiple: true }

      # Display existing images with an option to remove them (method assumed to be implemented)
      if f.object.images.attached?
        ul do
          f.object.images.each do |image|
            li do
              span image_tag(image.variant(resize_to_limit: [100, 100]))
              # If you implement a method to remove images, you can add a delete link here
              # span link_to 'Remove', delete_image_path(image.id), method: :delete
            end
          end
        end
      end
    end
    f.actions
  end

  show do |product|
    attributes_table do
      row :name
      row :description
      row :price
      row :stock_quantity
      row :category do
        product.category.name if product.category
      end
      row :on_sale # Display the "on sale" status in the show page
      # Display multiple attached images
      row :images do
        div do
          product.images.each do |img|
            div do
              image_tag img.variant(resize_to_limit: [100, 100]).processed
            end
          end
        end if product.images.attached?
      end
    end
  end
end
