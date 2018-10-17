class DropProductTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :products
    add_reference :plans, :size, foreign_key: true
  end
end
