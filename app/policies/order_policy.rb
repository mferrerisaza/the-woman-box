class OrderPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    new?
  end

  def edit?
    record.user == user
  end

  def update?
    edit?
  end

  def order_of_current_user?
    edit?
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
