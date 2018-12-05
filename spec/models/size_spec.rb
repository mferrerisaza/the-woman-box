require 'rails_helper'

RSpec.describe Size, type: :model do
  let(:size) { FactoryBot.build(:size) }
  let(:size_with_plans) { FactoryBot.create(:size, :with_plans) }

  it "is valid with a name and a type" do
    expect(size).to be_valid
  end

  it "is invalid without a name" do
    size.name = nil
    expect(size).to_not be_valid
    expect(size.errors.messages).to have_key(:name)
  end

  it "is invalid without a type" do
    size.type = nil
    expect(size).to_not be_valid
    expect(size.errors.messages).to have_key(:type)
  end

  it "is invalid with a duplicated name" do
    first_size = FactoryBot.create(:size)
    second_size = Size.new(type: first_size.type, name: first_size.name)
    expect(second_size).to_not be_valid
    expect(second_size.errors.messages).to have_key(:name)
  end

  it "can have many plans" do
    expect(size_with_plans.plans.size).to eq 10
  end
end
