ActiveAdmin.register Order do
  permit_params :shipping_address, :payment_method, :user_id, :status, :pst, :gst, :hst, :tax_total, :total_with_tax
  filter :shipping_address

  index do
    selectable_column
    id_column
    column :user do |order|
      order.user.email if order.user
    end
    column :shipping_address
    column :status
    column :pst
    column :gst
    column :hst
    column :tax_total
    column :total_before_tax
    column :total_with_tax
    column :created_at
    actions
  end


  filter :user
  filter :shipping_address
  filter :status
  filter :created_at

  show do |order|
    attributes_table do
      row :user do
        order.user.email if order.user
      end
      row :shipping_address
      row :province do
        # Access the province's name attribute
        order.user.province.name if order.user&.province
      end
      row :status
      row :created_at
      row :updated_at
      row :pst
      row :gst
      row :hst
      row :tax_total
      row :total_before_tax do
        number_to_currency(order.total_before_tax)
      end
      row :tax_total do
        number_to_currency(order.tax_amount)
      end
      row :total_with_tax do
        number_to_currency(order.total_with_tax)
      end
    end


    panel "Order Items" do
      table_for order.order_items do
        column :product do |order_item|
          order_item.product.name
        end
        column :quantity
        column :unit_price do |order_item|
          number_to_currency(order_item.unit_price)
        end
        column :total_price do |order_item|
          number_to_currency(order_item.quantity * order_item.unit_price)
        end
      end
    end
    active_admin_comments
  end


  form do |f|
    f.inputs do
      f.input :user, as: :select, collection: User.all.map { |u| [u.email, u.id] }
      f.input :shipping_address
      f.input :status, as: :select, collection: ['pending', 'completed', 'cancelled']
      # Include other fields as necessary
    end
    f.actions
  end

  # Override the controller actions as necessary
  controller do
    def create
      @order = Order.new(permitted_params[:order])
      if @order.save
        redirect_to admin_order_path(@order), notice: 'The order has been successfully created.'
      else
        render :new
      end
    end
  end
end
