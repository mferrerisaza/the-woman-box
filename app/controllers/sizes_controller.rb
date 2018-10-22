class SizesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized, :verify_policy_scoped

  def index
    @sizes = nil # creates an anonymous scope
    @sizes = Size.where(type_id: params[:type_id]) if params[:type_id].present?
    render json: @sizes
  end
end
