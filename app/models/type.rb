class Type < ApplicationRecord
  has_many :sizes
  has_many :products, through: :sizes
end
