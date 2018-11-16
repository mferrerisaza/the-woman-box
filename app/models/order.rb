class Order < ApplicationRecord
  enum status: %w[Pendiente Pagada Cancelada Inactiva Incompleta]
  belongs_to :user

  validates :last_period, :address, :country, :province, :city, presence: true, on: :update
  validates :country, inclusion: { in: ["CO"], message: "No disponbile para envío " }, on: :update

  monetize :amount_cents

  def next_period_start
    subscription_id = JSON.parse(payment)["subscription"]["_id"]
    subscription = Epayco::Subscriptions.get subscription_id
    Date.parse(subscription[:current_period_end]) + 1
  end

  def delivery_date
    delivery_margin = created_at + 10.days
    return 10 if delivery_margin.day >= 1 && delivery_margin.day <= 10
    return 20 if delivery_margin.day > 10 && delivery_margin.day <= 20
    return "último día"
  end

  def epayco_status_transform(epayco_status)
    order_status = ""
    if epayco_status == "canceled"
      order_status = "Cancelada"
    elsif epayco_status == "inactive"
      order_status = "Inactiva"
    elsif epayco_status == "pending"
      order_status = "Pendiente"
    elsif epayco_status == "active"
      order_status = "Pagada"
    else
      order_status = "Incompleta"
    end
    order_status
  end
end
