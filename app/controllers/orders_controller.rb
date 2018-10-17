class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    raise
    plan = Plan.find(params[:plan_id])
    order = Order.create!(plan_sku: plan.sku, amount: plan.price, status: 'Pendiente', user: current_user)
    redirect_to new_order_payment_path(order)
  end
end
