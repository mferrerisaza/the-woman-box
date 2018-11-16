class UpdateOrderStatusJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    user_orders = Order.where(user: user).where.not(status: "Incompleta")
    user_orders.each do |order|
      subscription_id = JSON.parse(order.payment)["subscription"]["_id"]
      subscription = Epayco::Subscriptions.get subscription_id
      subscription_status = subscription[:status_plan]
      order.update(status: order.epayco_status_transform(subscription_status))
    end
    # Para consultar el estado de una transaccion
    # Epayco::Charge.get "numero de factura que llega al email"[:x_response]
  end
end
