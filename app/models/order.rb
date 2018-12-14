class Order < ApplicationRecord
  enum status: %w[Pendiente Pagada Cancelada Inactiva Incompleta]
  belongs_to :user
  validates :last_period, :address, :country, :province, :city, presence: true, on: :update
  validates :country, inclusion: { in: ["CO"], message: "No disponbile para envío " }, on: :update

  monetize :amount_cents

  def next_period_start
    subscription_id = JSON.parse(payment)["subscription"]["_id"]
    subscription = Epayco::Subscriptions.get subscription_id
    Date.parse(subscription[:current_period_end]) + 1
  end

  def delivery_date_message
    unless self.delivery_date.day == 30
      return delivery_date.day
    end
    return "último día"
    # delivery_margin = created_at + 10.days
    # return 10 if delivery_margin.day >= 1 && delivery_margin.day <= 10
    # return 20 if delivery_margin.day > 10 && delivery_margin.day <= 20
    # return "último día"
  end

  def delivery_date
    delivery_margin = created_at + 10.days
    if delivery_margin.day >= 1 && delivery_margin.day <= 10
      parse_delivery_date(10, delivery_margin)
    elsif delivery_margin.day > 10 && delivery_margin.day <= 20
      parse_delivery_date(20, delivery_margin)
    else
      parse_delivery_date(30, delivery_margin)
    end
  end

  def epayco_status_transform(epayco_status)
    order_status = ""
    if epayco_status == "canceled"
      order_status = "Cancelada"
    elsif epayco_status == "inactive"
      order_status = "Inactiva"
    elsif epayco_status == "pending"
      order_status = "Pendiente"
    elsif epayco_status == "active"
      order_status = "Pagada"
    else
      order_status = "Incompleta"
    end
    order_status
  end

  def double_box?
    period_duration = 28
    days_between_use_and_next_delivery.to_i > ((double_box_counter) * period_duration)
  end

  private

  def first_period_subsribed
    period_t = Date.parse(last_period) + 28
    return period_t if (period_t >= next_delivery)
    return period_t + 28
  end

  def anticipation_days
    # How many days in advance we delivered fisthe box against next user period
    ((first_period_subsribed + (30 * deliveries).days) - next_delivery).to_i
  end

  def delivery_dates_difference
    ((next_delivery + 1.month) - next_delivery).to_i
  end


  def days_between_use_and_next_delivery
    # How many days between the use of the box and the next delivery
    (delivery_dates_difference - anticipation_days).to_i
  end


  def double_box_counter
    count = 0
    if days_between_use_and_next_delivery > (28 * count + 1)
      count += 1
    end
    count
  end

  def parse_delivery_date(day, delivery_margin)
    Date.parse("`#{day}-#{delivery_margin.month}-#{delivery_margin.year}`")
  end
end
