class Size < ApplicationRecord
  belongs_to :type
  has_many :plans

  validates :name, presence: true, uniqueness: true
end
