class Plan < ApplicationRecord
  has_many :orders
  monetize :price_centavos
end
