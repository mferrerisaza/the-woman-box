class PlansController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized, :verify_policy_scoped

  def index
    @plans = Plan.where(nil) # creates an anonymous scope
    # @plans = @plans.where(size_id: params[:size_id]) if params[:size_id].present?
    if params[:plan_type].present? && params[:size_id].present?
      @plans = @plans.where(size_id: params[:size_id]).where(billing_type: params[:plan_type])
    else
      @plans = nil
    end
    render json: @plans
  end

  def select_plan
  end
end
