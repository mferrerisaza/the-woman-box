class Plan < ApplicationRecord
  enum billing_type: %w[Recurrente 1Mes 3Meses 6Meses]

  monetize :price_cents
  belongs_to :size
  validates :sku, presence: true, uniqueness: true

  mount_uploader :photo, PhotoUploader
end
