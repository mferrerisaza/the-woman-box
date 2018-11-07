class ChangeDeliveryDateName < ActiveRecord::Migration[5.2]
  def change
    rename_column :orders, :delivery_date, :last_period
  end
end
