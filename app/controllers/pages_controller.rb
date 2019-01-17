class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :privacy_policy, :terms_and_conditions]

  def home
    @plans = Plan.all
  end

  def privacy_policy
  end

  def terms_and_conditions
  end

  def deliveries
    @users = policy_scope(User).order(created_at: :desc)
    authorize @users
  end

  def referral_program
    if current_user.one_month_plan_counter == current_user.orders.size
      message = "No puedes participar del programa de referidos con tu plan actual, este solo aplica para planes superiores a un mes"
    end
    unless current_user.active_orders? || current_user.admin
      message = "Aún no tienes una suscripción activa"
    end
    redirect_to root_path, alert: message if message.present?
    @referred_users = User.number_of_referred_users_with_active_orders(current_user.id)
  end
end
