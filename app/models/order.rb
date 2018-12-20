class Order < ApplicationRecord
  enum status: %w[Pendiente Pagada Cancelada Inactiva Incompleta]
  belongs_to :user
  validates :last_period, :address, :country, :province, :city, presence: true, on: :update
  validates :country, inclusion: { in: ["CO"], message: "No disponbile para envío " }, on: :update

  monetize :amount_cents

  PERIOD_DURATION = 28

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
  end

  def delivery_date
    delivery_margin = created_at + 10.days
    if delivery_margin.day >= 1 && delivery_margin.day <= 10
      parse_delivery_date(10, delivery_margin, self)
    elsif delivery_margin.day > 10 && delivery_margin.day <= 20
      parse_delivery_date(20, delivery_margin, self)
    else
      parse_delivery_date(30, delivery_margin, self)
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
    # Run
    # rails orders:update_next_deliveries
    # To update double_box and next delivery dates for all orders
    days_between_use_and_next_delivery.to_i > PERIOD_DURATION
  end

  private

  def first_period_subsribed
    period_t = Date.parse(last_period) + PERIOD_DURATION
    return period_t if (period_t >= (next_delivery - deliveries.months))
    return period_t + 28
  end

  def anticipation_days
    # How many days in advance we delivered fisthe box against next user period
    ad = ((first_period_subsribed + (PERIOD_DURATION * deliveries).days) - next_delivery).to_i
    return ad if ad > 0 # This means "delivering with anticipation"
    ad += 30 while ad < 0 # Loop to return a integer when we deliver with anticipation
    return ad
  end

  def delivery_dates_difference
    # Next month delivery - This month delivery
    return ((next_delivery + 1.month) - next_delivery).to_i if next_delivery
    # Add delivery date to the order in case it doesn't have it
    self.update(next_delivery: delivery_date)
    ((next_delivery + 1.month) - next_delivery).to_i
  end


  def days_between_use_and_next_delivery
    # How many days between the use of the box and the next delivery
    (delivery_dates_difference - anticipation_days).to_i
  end

  def parse_delivery_date(day, delivery_margin, order)
    next_delivery = Date.parse("`#{day}-#{delivery_margin.month}-#{delivery_margin.year}`")
    order.update(deliveries: 0) unless order.deliveries?
    next_delivery + order.deliveries.months
  end
end
