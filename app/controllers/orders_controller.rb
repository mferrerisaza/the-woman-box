class OrdersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_order, only: %i[edit update]
  skip_after_action :verify_authorized, only: :create

  def index
    @orders = policy_scope(Order).order(status: :asc, created_at: :desc)
  end

  def new
    @order = Order.new
    authorize @order
  end

  def create
    plan = Plan.find(order_params[:plan_id])
    if current_user
      order = Order.create!(plan_sku: plan.sku, amount: plan.price, status: 'Pendiente', user: current_user)
      redirect_to edit_order_path(order)
    else
      session[:order] = { plan_sku: plan.sku, amount: plan.price.to_i, status: 'Pendiente' }
      redirect_to new_user_registration_path
    end
  end

  def edit
    authorize @order
    @plan = Plan.find_by(sku: @order.plan_sku)
  end

  def update
    authorize @order
    if @order.update(order_params)
      redirect_to new_order_payment_path(@order)
    else
      render 'edit'
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(
      :plan_id,
      :last_period,
      :address,
      :country,
      :province,
      :city,
      :address_aditional_info
    )
  end
end
