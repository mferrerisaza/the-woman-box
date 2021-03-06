class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :capture_referal

  include Pundit

  # Pundit: white-list approach.
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # Uncomment when you *really understand* Pundit!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "No estás autorizado para realizar esta acción."
    redirect_to(root_path)
  end

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
      edit_order_path(order)
    else
      select_plan_path
    end
  end

  def default_url_options
    { host: ENV["HOST"] || "localhost:3000" }
  end

  def capture_referal
    session[:referred_by] = params[:referred_by] if params[:referred_by]
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  protected

  def configure_permitted_parameters
    added_attrs_on_signup = %i[phone first_name last_name email password password_confirmation remember_me referred_by]
    added_attrs_on_update = %i[phone first_name last_name email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs_on_signup
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs_on_update
  end
end
