class Order < ApplicationRecord
  belongs_to :plan
  belongs_to :user

  monetize :amount_cents
end
