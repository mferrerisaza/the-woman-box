class OrdersController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @order = Order.new
  end

  def create
    plan = Plan.find(order_params[:plan_id])
    order = Order.create!(plan_sku: plan.sku, amount: plan.price, status: 'Pendiente', user: current_user)
    redirect_to new_order_payment_path(order)
  end

  private

  def order_params
    params.require(:order).permit(:plan_id)
  end
end
