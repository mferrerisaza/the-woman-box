namespace :plans do
  desc "Add billing_type to existing monthly subscription plans"
  task update_billing_type: :environment do
    plans = Plan.all
    plans.each do |plan|
      plan.update(billing_type: "Recurrente")
    end
  end

  desc "Adds new plans that are not recurring form the csv file"
  task add_new_plans: :environment do
    filepath = 'Seeds The Women Box - Bundles.csv'
    csv_options = {col_sep: ',', quote_char: '"', headers: :first_row }

    CSV.foreach(filepath, csv_options) do |row|
      puts "Creando plan #{row['Plan_sku']} en la base de datos"
      size = Size.find(row['tamaño'])
      plan = Plan.create!(
        sku: row['Plan_sku'],
        size: size,
        name: row['Nombre'],
        description: row['descripción'],
        billing_type: row['billing_type'],
        price: row['precio'].gsub("$", "").gsub(".", "").to_i
      )
      plan.remote_photo_url = row['url_foto_marca']
      plan.save!
    end
  end
end
