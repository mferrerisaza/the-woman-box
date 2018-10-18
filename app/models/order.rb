class Order < ApplicationRecord
  enum status: %w[Pendiente Pagada]
  belongs_to :user, optional: true

  monetize :amount_cents
end
