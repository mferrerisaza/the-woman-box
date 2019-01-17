class UpdateOrderStatusJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    user_orders = Order.where(user: user).where.not(payment: nil)
    user_orders.each do |order|
      plan_billing_type = Plan.find_by(sku: order.plan_sku).billing_type
      if plan_billing_type == "Recurrente"
        subscription_id = JSON.parse(order.payment)["subscription"]["_id"]
        subscription = Epayco::Subscriptions.get subscription_id
        subscription_status = subscription[:status_plan]
        order.update(status: order.epayco_status_transform(subscription_status))
      else
        update_status_on_one_off_payments(order)
      end
    end
    # Para consultar el estado de una transaccion
    # Epayco::Charge.get "numero de factura que llega al email"[:x_response]
  end

  def update_status_on_one_off_payments(order)
    if order.status == "Pendiente"
      transaction_id = JSON.parse(order.payment)["data"]["x_ref_payco"].to_s
      transaction = Epayco::Charge.get transaction_id
      transaction_status = transaction[:data][:x_response]
      order.update(status: order.epayco_status_transform(transaction_status))
    end
    order.update(status: "Inactiva") if order.remaining_active_days <= 0 && order.status == "Pagada"
  end
end
