class PaymentsController < ApplicationController
  before_action :set_order

  def new
  end

  def create
    strong_params = card_params
    credit_info = {
        'card[number]': strong_params[:number],
        'card[exp_year]': strong_params[:exp_year],
        'card[exp_month]': strong_params[:exp_month],
        'card[cvc]': strong_params[:cvc]
    }

    begin
      token = Epayco::Token.create credit_info
    rescue Epayco::Error => e
      p e
    end

    if token[:id]
      current_user.update(epayco_token: token[:id])
      redirect_to
    else
      flash.now[:alert] = "No hemos podido completar tu solicitud, intentalo nuevamente"
      render 'new'
    end
  end

  private

  def set_order
    @order = current_user.orders.where(status: 'Pendiente').find(params[:order_id])
  end

  def card_params
    params.require(:card).permit(:name, :email, :number, :cvc, :exp_month, :exp_year)
  end
end
