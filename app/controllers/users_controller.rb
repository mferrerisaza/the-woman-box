class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    authorize @user
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
