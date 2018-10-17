class Order < ApplicationRecord
  enum status: %w[Pendiente Pagada]
  belongs_to :user

  monetize :amount_cents
end
