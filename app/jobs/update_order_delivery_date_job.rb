class UpdateOrderDeliveryDateJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find(order_id)
    order.update(next_delivery: order.delivery_date)
    order.update(next_double: order.double_box?)
  end
end
