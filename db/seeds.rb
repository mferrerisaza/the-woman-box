User.destroy_all
Plan.destroy_all
Order.destroy_all

puts "Creando usuarios"
mike = User.create!(name: "Mike", email: "mike@gmail.com", password:"123456", phone: "3148509472", address: "Calle 11a 42 18")
dan = User.create!(name: "Dan", email: "dan@gmail.com", password:"123456", phone: "3148509472", address: "Calle 11a 42 18")
puts "Done"

puts "Creando tipos"
tampon = Type.create!(name: "Tampones")
pad = Type.create!(name: "Toallas Higiénicas")

puts "Creando Tamaños de Toallas"
Size.create!(name: "Protectores", type: pad)
Size.create!(name: "Doble hoja", type: pad)
Size.create!(name: "Natural", type: pad)
Size.create!(name: "Tipo tanga", type: pad)
Size.create!(name: "Nocturnos", type: pad)

puts "Creando Tipos de Tampones"
Size.create!(name: "Mini", type: tampon)
Size.create!(name: "Regular", type: tampon)
Size.create!(name: "Super", type: tampon)
Size.create!(name: "Mini con aplicador", type: tampon)
Size.create!(name: "Regular con aplicador", type: tampon)
Size.create!(name: "Super con aplicador", type: tampon)

puts "Creando planes"

puts "Creando productos por marca"
pad_sizes = Size.where(type: pad)

pad_sizes.each do |size|
  Plan.create!(sku:"monthly#{size.id}",size: size, name: "#{size.type.name} #{size.name} Nosotras", description: "Suscribite para recibir la mejor cajita todos los meses", price: 30_000)
end


tampons_sizes = Size.where(type: tampon)

tampons_sizes.each do |size|
  Plan.create!(sku:"monthly#{size.id}",size: size, name: "#{size.type.name} #{size.name} OB", description: "Suscribite para recibir la mejor cajita todos los meses", price: 30_000)
end
puts "Tolis el llopo"
