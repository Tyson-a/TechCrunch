ActiveAdmin.register Order do
  permit_params :shipping_address, :payment_method, :user_id, :status # Include other fields as necessary

  index do
    selectable_column
    id_column
    column :user do |order|
      order.user.email if order.user
    end
    column :created_at
    column :status
    actions
  end

  filter :user
  filter :status
  filter :created_at

  show do |order|
    attributes_table do
      row :user do
        order.user.email if order.user
      end
      row :address
      row :status
      row :created_at
      row :updated_at
    end
    panel "Cart Items" do
      table_for order.user.cart.cart_items do
        column :product
        column :quantity
        column :price
      end
    end
    active_admin_comments
  end
  form do |f|
    f.inputs do
      f.input :user, as: :select, collection: User.all.map { |u| [u.email, u.id] }
      f.input :address
      f.input :status, as: :select, collection: ['pending', 'completed', 'cancelled']
    end
    f.actions
  end

  controller do
    def create
      @order = Order.new(permitted_params[:order])
      @order.user = current_user
      @order.status = 'pending'
      # Add your logic to transfer items from cart to order
      if @order.save
        # Handle payment processing here if necessary
        redirect_to admin_order_path(@order), notice: 'Thank you for your order.'
      else
        render :new
      end
    end
  end
end
