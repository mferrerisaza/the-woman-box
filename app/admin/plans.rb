ActiveAdmin.register Plan do
  permit_params :sku, :size, :name, :on, :description, :price, :photo
end
