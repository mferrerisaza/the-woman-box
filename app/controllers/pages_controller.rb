class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :privacy_policy, :terms_and_conditions]

  def home
    @plans = Plan.all
  end

  def privacy_policy
  end

  def terms_and_conditions
  end

  def referral_program
  end
end
