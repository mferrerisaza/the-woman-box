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

  def one_month_plan_counter
    one_month_plans = 0
    orders.each do |order|
      one_month_plans += 1 if order.plan_sku[0..5] == "1Month"
    end
    one_month_plans
  end

  def self.number_of_referred_users(id)
    where(referred_by: id).count
  end

  def self.number_of_referred_users_with_active_orders(id)
    where(referred_by: id).joins(:orders).where( orders: { status: "Pagada" }).count
  end

end
