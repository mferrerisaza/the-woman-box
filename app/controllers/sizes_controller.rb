class SizesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @sizes = nil # creates an anonymous scope
    @sizes = Size.where(type_id: params[:type_id]) if params[:type_id].present?
    render json: @sizes
  end
end
