class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    record.id == user.id
  end

  def deliveries?
    user.admin?
  end
end
