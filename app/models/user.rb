class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :orders, dependent: :nullify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :phone, presence: true
  DOC_TYPE = %w[NIT CC CE TI PPN SSN LIC DNI]

  def full_name
    "#{first_name} #{last_name}".split.map(&:capitalize).join(' ')
  end

  def tokenized?
    epayco_token ? true : false
  end

  def is_epayco_customer?
    epayco_customer_id ? true : false
  end
end
