class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :name
      t.string :description
      t.monetize :price, currency: { present: false }

      t.timestamps
    end
  end
end
