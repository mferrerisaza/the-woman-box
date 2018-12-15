namespace :orders do
  desc "Update all status of complete orders"
  task update_all_status: :environment do
    users = User.all
    users.each do |user|
      UpdateOrderStatusJob.perform_now(user.id)
    end
  end

  desc "Update next delivery dates"
  task update_next_deliveries: :environment do
    orders = Order.where(status: "Pagada")
    orders.each do |order|
      UpdateOrderDeliveryDateJob.perform_now(order.id)
    end
  end
end
