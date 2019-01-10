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
    redirect_to root_path, alert: "Aún no tienes una suscripción activa" unless current_user.active_orders? || current_user.admin
    @referred_users = User.number_of_referred_users_with_active_orders(current_user.id)
  end
end
