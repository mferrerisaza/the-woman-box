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
end
