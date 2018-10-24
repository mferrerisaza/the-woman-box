class Order < ApplicationRecord
  enum status: %w[Pendiente Pagada]
  belongs_to :user

  validates :delivery_date, :address, :country, :province, :city, presence: true, on: :update
  validates :country, inclusion: { in: ["CO"], message: "No disponbile para envío " }, on: :update

  monetize :amount_cents
end
