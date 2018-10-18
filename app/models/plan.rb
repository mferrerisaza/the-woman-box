class Plan < ApplicationRecord
  monetize :price_cents
  belongs_to :size
  validates :sku, presence: true, uniqueness: true

  mount_uploader :photo, PhotoUploader
end
