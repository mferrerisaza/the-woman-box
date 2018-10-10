User.destroy_all
Plan.destroy_all
Order.destroy_all

puts "Creando usuarios"
mike = User.create!(name: "Mike", email: "mike@gmail.com", password:"123456", phone: "3148509472", address: "Calle 11a 42 18")
dan = User.create!(name: "Dan", email: "dan@gmail.com", password:"123456", phone: "3148509472", address: "Calle 11a 42 18")
puts "Done"

puts "Creando planes"
plan = Plan.create!(name: "Suscripcion Mensual", description: "Suscribite para recibir la mejor cajita todos los meses", price: 30_000)
puts "Tolis el llopo"
