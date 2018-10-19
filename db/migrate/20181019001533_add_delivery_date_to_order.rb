class AddDeliveryDateToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :delivery_date, :string
  end
end
