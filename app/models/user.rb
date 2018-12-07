class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :orders, dependent: :nullify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :referrer, class_name: 'User', foreign_key: 'referred_by', optional: true

  validates :first_name, :last_name, :phone, presence: true
  DOC_TYPE = %w[NIT CC CE TI PPN SSN LIC DNI]

  def full_name
    "#{first_name} #{last_name}".split.map(&:capitalize).join(' ')
  end

  def tokenized?
    epayco_token ? true : false
  end

  def epayco_customer?
    epayco_customer_id ? true : false
  end

  def all_orders_cancelled?
    orders.where(status: "Cancelada").size == orders.size
  end

  def active_orders?
    orders.where(status: "Pagada").size.positive?
  end

  def self.number_of_referred_users(id)
    # Cambar para que funcione pasando solo los usuarios referidos con ordenes activas
    where(referred_by: id).count
  end
end
