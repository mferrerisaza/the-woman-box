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
# puts "Creando usuarios"
# mike = User.create!(first_name: "Mike", last_name: "Ferrer", email: "mike@gmail.com", password:"123456", phone: "3148509472")
# dan = User.create!(first_name: "Dan", last_name: "López", email: "dan@gmail.com", password:"123456", phone: "3148509472")
# puts "Done"

# tampon = Type.create!(name: "Tampones")
# pad = Type.create!(name: "Toallas Higiénicas")

# puts "Creando Tamaños de Toallas"
# Size.create!(name: "Protectores", type: pad)
# Size.create!(name: "Doble hoja", type: pad)
# Size.create!(name: "Natural", type: pad)
# Size.create!(name: "Tipo tanga", type: pad)
# Size.create!(name: "Nocturnos", type: pad)

# puts "Creando Tipos de Tampones"
# Size.create!(name: "Mini", type: tampon)
# Size.create!(name: "Regular", type: tampon)
# Size.create!(name: "Super", type: tampon)
# Size.create!(name: "Mini con aplicador", type: tampon)
# Size.create!(name: "Regular con aplicador", type: tampon)
# Size.create!(name: "Super con aplicador", type: tampon)

# puts "Creando planes"

# puts "Creando productos por marca"
# pad_sizes = Size.where(type: pad)

# pad_sizes.each do |size|
#   plan = Plan.create!(
#     sku:"monthly#{size.id}nosotras",
#     size: size,
#     name: "#{size.type.name} #{size.name} Nosotras",
#     description: "Suscribite para recibir la mejor cajita todos los meses",
#     price: 35_000
#   )
#   plan.remote_photo_url = "https://vignette.wikia.nocookie.net/logopedia/images/e/eb/Nosotras-logo.png/revision/latest?cb=20180904011023&path-prefix=es"
#   plan.save!

#   plan_info = {
#     id_plan: plan.sku,
#     name: plan.name,
#     description: plan.description,
#     amount: plan.price.to_i,
#     currency: "cop",
#     interval: "month",
#     interval_count: 1,
#     trial_days: 0
#   }

#   begin
#       plan = Epayco::Plan.create plan_info
#   rescue Epayco::Error => e
#       puts e
#   end
# end

#   pad_sizes.each do |size|
#   plan = Plan.create!(
#     sku:"monthly#{size.id}OB",
#     size: size,
#     name: "#{size.type.name} #{size.name} OB",
#     description: "Suscribite para recibir la mejor cajita todos los meses",
#     price: 35_000
#   )
#   plan.remote_photo_url = "https://seeklogo.com/images/O/o_b_-logo-C64CD5FA3B-seeklogo.com.png"
#   plan.save!

#     plan_info = {
#     id_plan: plan.sku,
#     name: plan.name,
#     description: plan.description,
#     amount: plan.price.to_i,
#     currency: "cop",
#     interval: "day",
#     interval_count: 1,
#     trial_days: 0
#   }

#   begin
#       plan = Epayco::Plan.create plan_info
#   rescue Epayco::Error => e
#       puts e
#   end
# end


# tampons_sizes = Size.where(type: tampon)

# tampons_sizes.each do |size|
#   plan = Plan.new(
#     sku:"monthly#{size.id}OB",
#     size: size,
#     name: "#{size.type.name} #{size.name} OB",
#     description: "Suscribite para recibir la mejor cajita todos los meses",
#     price: 35_000
#   )
#   plan.remote_photo_url = "https://seeklogo.com/images/O/o_b_-logo-C64CD5FA3B-seeklogo.com.png"
#   plan.save!

#     plan_info = {
#     id_plan: plan.sku,
#     name: plan.name,
#     description: plan.description,
#     amount: plan.price.to_i,
#     currency: "cop",
#     interval: "day",
#     interval_count: 1,
#     trial_days: 0
#   }

#   begin
#       plan = Epayco::Plan.create plan_info
#   rescue Epayco::Error => e
#       puts e
#   end
# end

#   tampons_sizes.each do |size|
#   plan = Plan.new(
#     sku:"monthly#{size.id}nosotras",
#     size: size,
#     name: "#{size.type.name} #{size.name} Nosotras",
#     description: "Suscribite para recibir la mejor cajita todos los meses",
#     price: 35_000
#   )
#   plan.remote_photo_url = "https://vignette.wikia.nocookie.net/logopedia/images/e/eb/Nosotras-logo.png/revision/latest?cb=20180904011023&path-prefix=es"
#   plan.save!

#     plan_info = {
#     id_plan: plan.sku,
#     name: plan.name,
#     description: plan.description,
#     amount: plan.price.to_i,
#     currency: "cop",
#     interval: "day",
#     interval_count: 1,
#     trial_days: 0
#   }

#   begin
#       plan = Epayco::Plan.create plan_info
#   rescue Epayco::Error => e
#       puts e
#   end
# end
# puts "Tolis el llopo"
