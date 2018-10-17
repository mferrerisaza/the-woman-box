class Plan < ApplicationRecord
  monetize :price_cents

  validates :sku, presence: true, uniqueness: true
end
