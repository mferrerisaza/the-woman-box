class Plan < ApplicationRecord
  has_many :orders, dependent: :nullify
  monetize :price_centavos
end
