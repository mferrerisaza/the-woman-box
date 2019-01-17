class AddBillingTypeToPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :billing_type, :integer
  end
end
