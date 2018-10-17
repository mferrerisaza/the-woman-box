class Size < ApplicationRecord
  belongs_to :type
  has_many :plans
end
