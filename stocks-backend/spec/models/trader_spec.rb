require 'rails_helper'

RSpec.describe Trader, type: :model do
  it "is not saved because email is already taken" do 
    existing_admin = FactoryBot.create(:admin, email: 'user@mail.com')
    trader = FactoryBot.build(:trader, email: 'user@mail.com')

    expect(trader.save).to be false
  end
end
