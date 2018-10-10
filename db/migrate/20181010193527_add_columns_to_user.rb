class AddColumnsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :epayco_token, :string
    add_column :users, :epayco_customer_id, :string
    add_column :users, :name, :string
    add_column :users, :doc_type, :string
    add_column :users, :doc_number, :string
    add_column :users, :phone, :string
    add_column :users, :address, :string
  end
end
