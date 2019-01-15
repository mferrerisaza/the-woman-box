class PlansController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized, :verify_policy_scoped

  def index
    @plans = nil # creates an anonymous scope
    @plans = Plan.where(size_id: params[:size_id]) if params[:size_id].present?
    render json: @plans
  end

  def select_plan
  end
end
