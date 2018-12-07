class AddDeliveryColumnsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :next_delivery, :date
    add_column :orders, :next_double, :date
  end
end
