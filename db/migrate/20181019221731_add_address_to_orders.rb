class AddAddressToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :address, :string
    add_column :orders, :city, :string
    add_column :orders, :province, :string
    add_column :orders, :country, :string
    add_column :orders, :address_aditional_info, :string
    remove_column :users, :address
  end
end
