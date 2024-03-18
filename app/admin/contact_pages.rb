# app/admin/contact_pages.rb
ActiveAdmin.register ContactPage do
  permit_params :title, :content

  form do |f|
    f.inputs do
      f.input :title
      f.input :content, as: :text
    end
    f.actions
  end
end
