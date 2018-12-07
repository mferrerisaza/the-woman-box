require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { FactoryBot.build(:order) }

  context "on create" do
    it "is valid with plan_sku amount status and user" do
      expect(order).to be_valid
    end

    it "is invalid without a user" do
      order.user = nil
      expect(order).to_not be_valid
      expect(order.errors.messages).to have_key(:user)
    end
  end

  context "on update" do
    it "is valid with plan_sku amount status and user" do
      expect(order).to be_valid
    end

    it "is invalid without a user" do
      order.user = nil
      expect(order).to_not be_valid
      expect(order.errors.messages).to have_key(:user)
    end
  end
end
