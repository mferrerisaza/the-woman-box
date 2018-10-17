class OrdersController < ApplicationController
  def index
    @orders = current_user.orders
  end

  def create
    plan = Plan.find(params[:plan_id])
    order = Order.create!(plan_sku: plan.sku, amount: plan.price, status: 'Pendiente', user: current_user)
    redirect_to new_order_payment_path(order)
  end
end
