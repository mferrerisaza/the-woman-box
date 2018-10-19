class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if session[:order].present?
      create_order_after_user_sign_up(current_user)
    else
      super
    end
  end

  def create_order_after_user_sign_up(user)
    order = Order.new(session[:order])
    order.user = user
    session[:order] = nil
    if order.save
      new_order_payment_path(order)
    else
      new_order_path
    end
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:phone, :first_name, :last_name, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
