class OrdersController < ApplicationController
  skip_before_action :authenticate_user!, except: %i[index thank_you]
  before_action :set_order, only: %i[edit update]
  skip_after_action :verify_authorized, only: %i[create thank_you]

  def index
    UpdateOrderStatusJob.perform_now(current_user.id)
    @orders = policy_scope(Order).order(status: :asc, created_at: :desc)
  end

  def new
    @order = Order.new
    authorize @order
  end

  def create
    plan = Plan.find(order_params[:plan_id])
    if current_user
      order = Order.create!(plan_sku: plan.sku, amount: plan.price,
                            status: 'Incompleta', user: current_user, deliveries: 0)
      redirect_to edit_order_path(order)
    else
      session[:order] = { plan_sku: plan.sku, amount: plan.price.to_i, status: 'Incompleta', deliveries: 0 }
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
      set_next_delivery(@order)
      if @order.status == "Pagada"
        redirect_to orders_path
        flash[:notice] = "Tu información de envío ha sido actualizada con éxito"
      else
        redirect_to new_order_payment_path(@order)
      end
    else
      render 'edit'
    end
  end

  def thank_you
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

  def set_next_delivery(order)
    order.update(next_delivery: order.delivery_date)
    order.update(next_double: order.double_box?)
  end
end
