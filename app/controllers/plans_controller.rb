class PlansController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @plans = nil # creates an anonymous scope
    @plans = Plan.where(size_id: params[:size_id]) if params[:size_id].present?
    render json: @plans
  end
end
