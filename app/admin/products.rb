ActiveAdmin.register Product do
  # Add :on_sale to the list of permitted parameters
  permit_params :name, :description, :price, :stock_quantity, :category_id, :on_sale, images: []



  filter :category_id, as: :select, collection: -> { Category.all.map { |c| [c.name, c.id] } }

  member_action :delete_image, method: :delete do
    image = ActiveStorage::Attachment.find(params[:image_id])
    image.purge
    redirect_back(fallback_location: admin_product_path(params[:id]), notice: "Image was successfully deleted.")
  end

  controller do
    def create
      @product = Product.new(permitted_params[:product])

      # Manually assign timestamps if provided
      @product.created_at = params[:product][:created_at] if params[:product][:created_at].present?
      @product.updated_at = params[:product][:updated_at] if params[:product][:updated_at].present?

      if @product.save
        redirect_to admin_product_path(@product), notice: "Product was successfully created."
      else
        render :new
      end
    end

    def update
      @product = Product.find(params[:id])

      # Attach new images if any
      @product.images.attach(params[:product][:images]) if params[:product][:images]

      # Exclude images from product_params to handle them separately
      product_params = permitted_params[:product].except(:images, :created_at, :updated_at)

      # Manually update timestamps if provided
      @product.created_at = params[:product][:created_at] if params[:product][:created_at].present?
      @product.updated_at = params[:product][:updated_at] if params[:product][:updated_at].present?

      if @product.update(product_params)
        redirect_to admin_product_path(@product), notice: "Product was successfully updated."
      else
        render :edit
      end
    end
  end


  form do |f|
    f.semantic_errors # Handles displaying errors
    f.inputs 'Product Details' do
      # Your other product inputs
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :created_at, as: :datetime_picker
    f.input :updated_at, as: :datetime_picker
      f.input :category_id, as: :select, collection: Category.all.collect { |c| [c.name, c.id] }
      f.input :on_sale, as: :boolean # Add this line
      f.input :images, as: :file, input_html: { multiple: true }
      if f.object.images.attached?
        ul do
          f.object.images.each do |image|
            li do
              span image_tag(image.variant(resize_to_limit: [100, 100]))
              span link_to 'Remove', delete_image_admin_product_path(product_id: f.object.id, image_id: image.id), method: :delete, data: { confirm: 'Are you sure?' }
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
