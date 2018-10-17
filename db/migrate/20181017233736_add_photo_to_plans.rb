class AddPhotoToPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :photo, :string
  end
end
