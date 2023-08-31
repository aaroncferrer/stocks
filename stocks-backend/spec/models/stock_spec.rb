require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe "associations" do
    it "has many transactions" do
      association = Stock.reflect_on_association(:transactions)
      expect(association.macro).to eq(:has_many)
    end

    it "has many portfolios" do
      association = Stock.reflect_on_association(:portfolios)
      expect(association.macro).to eq(:has_many)
    end

    it "has many traders through transactions" do
      association = Stock.reflect_on_association(:traders)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:transactions)
    end
  end
end
