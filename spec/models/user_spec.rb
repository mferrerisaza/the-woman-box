require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }
  context "basic user info" do
    it "is valid with a email, password, first_name, last_name and phone" do
      expect(user).to be_valid
    end

    it "is invalid without a email" do
      user.email = nil
      expect(user).to_not be_valid
      expect(user.errors.messages).to have_key(:email)
    end

    it "is invalid without a password" do
      user.password = nil
      expect(user).to_not be_valid
      expect(user.errors.messages).to have_key(:password)
    end

    it "is invalid without a first_name" do
      user.first_name = nil
      expect(user).to_not be_valid
      expect(user.errors.messages).to have_key(:first_name)
    end

    it "is invalid without a last_name" do
      user.last_name = nil
      expect(user).to_not be_valid
      expect(user.errors.messages).to have_key(:last_name)
    end

    it "is invalid without a phone number" do
      user.phone = nil
      expect(user).to_not be_valid
      expect(user.errors.messages).to have_key(:phone)
    end

    it "can have many orders" do
      user_with_orders = FactoryBot.create(:user, :with_orders)
      expect(user_with_orders.orders.size).to eq 10
    end

    it "can have many referred users" do
      user_referring = FactoryBot.create(:user)
      FactoryBot.create(:user, referred_by: user_referring.id)
      FactoryBot.create(:user, referred_by: user_referring.id)
      expect(User.number_of_referred_users(user_referring.id)).to eq 2
    end

    it "counts the referred user with active orders" do
      user_referring = FactoryBot.create(:user)
      FactoryBot.create(:user, referred_by: user_referring.id)
      FactoryBot.create(:user, :with_active_orders, referred_by: user_referring.id)
      expect(User.number_of_referred_users_with_active_orders(user_referring.id)).to eq 1
    end

    it "belongs to one referrer" do
      user_referring = FactoryBot.create(:user)
      new_user = FactoryBot.create(:user, referred_by: user_referring.id)
      expect(new_user.referrer).to eq user_referring
    end
  end

  context "instance methods" do
    it "returns the correct full name" do
      user.first_name = "miguel"
      user.last_name = "ferrer isaza"
      expect(user.full_name).to eq "Miguel Ferrer Isaza"
    end

    it "returns true if user has epayco_token" do
      user.epayco_token = "ZJYvjNMnXdrFvrdit"
      expect(user.tokenized?).to eq true
    end

    it "returns false if user does not have epayco_token" do
      expect(user.tokenized?).to eq false
    end

    it "returns true if user has epayco customer id" do
      user.epayco_customer_id = "eYcZLws3dA3kToJ2S"
      expect(user.epayco_customer?).to eq true
    end

    it "returns true if user has epayco customer id" do
      expect(user.epayco_customer?).to eq false
    end

    it "returns true if has all orders cancelled" do
      user_with_orders = FactoryBot.create(:user, :with_cancelled_orders)
      expect(user_with_orders.all_orders_cancelled?).to eq true
    end

    it "returns false if has orders that are not cancelled" do
      user_with_orders = FactoryBot.create(:user, :with_orders)
      expect(user_with_orders.all_orders_cancelled?).to eq false
    end

    it "returns true if user has at least 1 active subscription" do
      user_with_orders = FactoryBot.create(:user, :with_active_orders)
      expect(user_with_orders.active_orders?).to eq true
    end

    it "returns false if user has at least 0 active subscription" do
      user_with_orders = FactoryBot.create(:user)
      expect(user_with_orders.active_orders?).to eq false
    end

    it "returns false if user do not have an active subscription" do
      user_with_orders = FactoryBot.create(:user, :with_orders)
      expect(user_with_orders.active_orders?).to eq false
    end
  end
end
