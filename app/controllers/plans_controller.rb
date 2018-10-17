class PlansController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render json: Plan.all
  end
end
