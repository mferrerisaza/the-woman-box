ActiveAdmin.register User do
  index do
    selectable_column
    column :id
    column :email
    column :full_name
    column :created_at
    column :updated_at
    column :epayco_token
    column :epayco_customer_id
    column :doc_type
    column :doc_number
    column :phone
    column :admin
    actions
  end

  form do |f|
    f.inputs "Identity" do
      f.input :email
    end
    f.inputs "Admin" do
      f.input :admin
    end
    f.actions
  end

  permit_params :name, :email, :admin
end
