ActiveAdmin.register Order do
  form do |f|
    f.inputs "Nueva Orden" do
      f.input :plan_sku, collection: Plan.all.map(&:sku)
      f.input :user
      f.input :amount
      f.input :status, selected: "Incompleta"
    end
    f.inputs "Editar Orden" do
      f.input :address
      f.input :country, selected: "CO"
      f.input :province
      f.input :city
      f.input :address_aditional_info
      f.input :last_period, as: :datepicker, datepicker_options: {
        min_date: 40.days.ago.to_date,
        max_date: 0.days.ago.to_date
      }
    end
    f.actions
  end
  permit_params :plan_sku, :status,:amount, :user_id, :last_period, :address, :country, :province, :city, :address_aditional_info
end
