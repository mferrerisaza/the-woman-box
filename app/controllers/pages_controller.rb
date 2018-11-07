class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @plans = Plan.all
  end

  def privacy_policy
  end

  def terms_and_conditions
  end
end
