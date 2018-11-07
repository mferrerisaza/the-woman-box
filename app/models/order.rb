class Order < ApplicationRecord
  enum status: %w[Pendiente Pagada Cancelada]
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
    created_at = self.created_at.to_date.day
    delivery_margin = created_at + 10
    return 10 if (delivery_margin > 30 && delivery_margin <= 40) && self.created_at.end_of_month.day < 31
    return 20 if (delivery_margin > 10 && delivery_margin <= 20) || delivery_margin > 40
    return "último día" unless self.created_at.end_of_month.day < 29
    return 10
  end
end
