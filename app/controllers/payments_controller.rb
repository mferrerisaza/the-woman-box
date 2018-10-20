class PaymentsController < ApplicationController
  before_action :set_order

  def new
    @plan = Plan.find_by(sku: @order.plan_sku)
  end

  def create
    create_card_token(card_params)
    create_epayco_customer(card_params)
    create_epayco_suscription(card_params)
    # create_epayco_customer(card_params)
  end

  private

  def create_card_token(card_params)
    credit_info = {
        'card[number]': card_params[:number],
        'card[exp_year]': card_params[:exp_year],
        'card[exp_month]': card_params[:exp_month],
        'card[cvc]': card_params[:cvc]
    }

    begin
      token = Epayco::Token.create credit_info
      puts token
    rescue Epayco::Error => e
      p e
    end

    token_id = token[:id]

    if token_id
      current_user.update(epayco_token: token_id)
    else
      flash.now[:alert] = "No hemos podido completar tu solicitud, intentalo nuevamente"
      @errors = token
      render 'new'
    end
  end

  def create_epayco_customer(card_params)
    customer_info = {
      token_card: current_user.epayco_token,
      name: card_params[:name],
      email: card_params[:email],
      phone: current_user.phone,
      default: true
    }

    begin
      customer = Epayco::Customers.create customer_info
      puts customer
    rescue Epayco::Error => e
      puts e
    end

    customer_id = customer[:data][:customerId]

    if customer_id
      current_user.update(epayco_customer_id: customer_id)
    else
      flash.now[:alert] = "No hemos podido completar tu solicitud, intentalo nuevamente"
      @errors = customer
      render 'new'
    end
  end

  def create_epayco_suscription(plan_params)
    subscription_info = {
      id_plan: plan_params[:plan_sku],
      customer: current_user.epayco_customer_id,
      token_card: current_user.epayco_token,
      doc_type: plan_params[:doc_type],
      doc_number: plan_params[:doc_number]
    }

    begin
      Epayco::Subscriptions.create subscription_info
      subscription = Epayco::Subscriptions.charge subscription_info
      puts subscription
    rescue Epayco::Error => e
      puts e
    end

    # customer_id = customer[:data][:customerId]

    # if customer_id
    #   current_user.update(epayco_customer_id: customer_id)
    # else
    #   flash.now[:alert] = "No hemos podido completar tu solicitud, intentalo nuevamente"
    #   @errors = customer
    #   render 'new'
    # end
  end

  def set_order
    @order = current_user.orders.where(status: 'Pendiente').find(params[:order_id])
  end

  def card_params
    params.require(:card).permit(
      :name,
      :email,
      :number,
      :cvc,
      :exp_month,
      :exp_year,
      :doc_type,
      :doc_number,
      :plan_sku
    )
  end

  def order_params
    params.require(:order).permit(:delivery_date, :address)
  end
end
