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
end
