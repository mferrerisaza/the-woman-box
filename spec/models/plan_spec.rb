require 'rails_helper'

RSpec.describe Plan, type: :model do
  let(:plan) { FactoryBot.build(:plan) }

  it "is valid with a name, description, price, sku, size" do
    expect(plan).to be_valid
  end

  it "is invalid without a sku" do
    plan.sku = nil
    expect(plan).to_not be_valid
    expect(plan.errors.messages).to have_key(:sku)
  end

  it "is invalid without a size" do
    plan.size = nil
    expect(plan).to_not be_valid
    expect(plan.errors.messages).to have_key(:size)
  end

  it "is invalid without a duplicate sku" do
    first_plan = FactoryBot.create(:plan)
    second_plan = Plan.new(FactoryBot.attributes_for(:plan, sku: first_plan.sku))
    expect(second_plan).to_not be_valid
    expect(second_plan.errors.messages).to have_key(:sku)
  end
end
