require 'rails_helper'

RSpec.describe Type, type: :model do
  let(:type) { FactoryBot.build(:type) }
  let(:type_without_name) { FactoryBot.build(:type, name: nil) }
  let(:type_with_sizes) { FactoryBot.create(:type, :with_sizes) }

  it "is valid with a name" do
    expect(type).to be_valid
  end

  it "is invalid with a name" do
    expect(type_without_name).to_not be_valid
    expect(type_without_name.errors.messages).to have_key(:name)
  end

  it "is invalid with a duplicated name" do
    FactoryBot.create(:type)
    expect(type).to_not be_valid
    expect(type.errors.messages).to have_key(:name)
  end

  it "can have many sizes" do
    expect(type_with_sizes.sizes.size).to eq 5
  end
end
