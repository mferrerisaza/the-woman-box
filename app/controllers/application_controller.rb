class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    if session[:order].present?
      create_order_after_user_sign_up(current_user)
    else
      super
    end
  end

  def create_order_after_user_sign_up(user)
    order = Order.new(session[:order])
    @order.user = user
    session[:order] = nil
    if @order.save
    else
    end
  end
end
