class RemovePlanOnOrders < ActiveRecord::Migration[5.2]
  def change
    remove_reference :orders, :plan, index: true, foreign_key: true
    add_column :orders, :plan_sku, :string
  end
end
