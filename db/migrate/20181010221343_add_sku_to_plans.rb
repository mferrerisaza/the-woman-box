class AddSkuToPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :sku, :string
  end
end
