class SizesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render json: Size.all
  end
end
