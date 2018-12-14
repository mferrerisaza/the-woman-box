class AddDeliveriesToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :deliveries, :int
  end
end
