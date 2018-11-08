require 'csv'

csv_options = {col_sep: ',', quote_char: '"', headers: :first_row }


filepath = 'Seeds The Women Box - Tipo.csv'

CSV.foreach(filepath, csv_options) do |row|
  puts "Creando tipo #{row['Tipo']}"
  Type.create!(name: row['Tipo'])
end

filepath = 'Seeds The Women Box - Tamaño.csv'

CSV.foreach(filepath, csv_options) do |row|
  puts "Creando Tamaño #{row['Tamaño']}"
  type = Type.find(row['Tipo'])
  Size.create!(name: row['Tamaño'], type: type)
end

filepath = 'Seeds The Women Box - Plan.csv'

CSV.foreach(filepath, csv_options) do |row|
  puts "Creando plan #{row['Plan_sku']} en la base de datos"
  size = Size.find(row['tamaño'])
  plan = Plan.create!(
    sku: row['Plan_sku'],
    size: size,
    name: row['Nombre'],
    description: row['descripción'],
    price: row['precio'].gsub(" $","").gsub(".","").to_i
  )
  plan.remote_photo_url = row['url_foto_marca']
  plan.save!

  puts "Creando plan #{row['Plan_sku']} en epayco"
  plan_info = {
    id_plan: plan.sku,
    name: plan.name,
    description: plan.description,
    amount: plan.price.to_i,
    currency: "cop",
    interval: "month",
    interval_count: 1,
    trial_days: 0
  }

  begin
      plan = Epayco::Plan.create plan_info
  rescue Epayco::Error => e
      puts e
  end
end
