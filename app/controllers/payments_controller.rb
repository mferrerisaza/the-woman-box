class PaymentsController < ApplicationController
  before_action :set_order, except: :cancel
  before_action :set_cancel_order, only: :cancel

  def new
    @plan = Plan.find_by(sku: @order.plan_sku)
    authorize @order, :order_of_current_user?
  end

  def create
    authorize @order, :order_of_current_user?
    create_card_token(card_params) # unless current_user.tokenized?
    create_epayco_customer(card_params) # unless current_user.is_epayco_customer?
    create_epayco_suscription(card_params)
  end

  def cancel
    authorize @order, :order_of_current_user?
    cancel_epayco_subscription(@order)
  end

  private

  def create_card_token(card_params)
    credit_info = {
      'card[number]': card_params[:number].gsub(/\s+/, ""),
      'card[exp_year]': card_params[:exp_year],
      'card[exp_month]': card_params[:exp_month],
      'card[cvc]': card_params[:cvc]
    }

    begin
      token = Epayco::Token.create credit_info
    rescue Epayco::Error => e
      p e
    end

    if token[:status]
      current_user.update(epayco_token: token[:id])
    else
      flash.now[:alert] = "#{token[:data][:description]}"
      # render 'new'
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
    rescue Epayco::Error => e
      puts e
    end

    if customer[:status]
      current_user.update(epayco_customer_id: customer[:data][:customerId])
    else
      flash.now[:alert] = "#{customer[:data][:description]}"
      # render 'new'
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
      charge = Epayco::Subscriptions.charge subscription_info
    rescue Epayco::Error => e
      puts e
    end

    if charge[:subscription]
      if charge[:subscription][:status] == "active"
        @order.update(payment: charge.to_json, status: 'Pagada')
      else
        @order.update(payment: charge.to_json)
      end
      redirect_to orders_path
    else
      flash.now[:alert] = "#{charge[:data][:description]}"
      render 'new'
    end
  end

  def cancel_epayco_subscription(order)
    begin
      subscription = Epayco::Subscriptions.cancel JSON.parse(order.payment)["subscription"]["_id"]
    rescue Epayco::Error => e
      puts e
    end
    if subscription[:status]
      order.update(status: 'Cancelada')
      flash[:notice] = "La suscripción ha sido cancelada"
    end
    redirect_to orders_path
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

  def set_cancel_order
    @order = Order.find(params[:order_id])
  end
end
