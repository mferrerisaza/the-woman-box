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

  context "instance methods" do
    it "returns the correct delivery date" do
      expect(order.delivery_date).to eq Date.parse("2018-12-30")
    end

    it "returns teh correct delivery date when 1st of month" do
      order.update(created_at: "2018-12-01")
      expect(order.delivery_date).to eq Date.parse("2018-12-20")
    end

    it "returns teh correct delivery date when last day of month" do
      order.update(created_at: "2018-11-30")
      expect(order.delivery_date).to eq Date.parse("2018-12-10")
    end

    it "return false if no double box" do
      expect(order.double_box?).to eq false
    end

    it "return true if double_box" do
      order.update(last_period: "2018-12-03")
      expect(order.double_box?).to eq true
    end
  end
end
