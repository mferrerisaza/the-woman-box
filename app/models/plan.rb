class Plan < ApplicationRecord
  monetize :price_cents
  belongs_to :size
  validates :sku, presence: true, uniqueness: true
end
