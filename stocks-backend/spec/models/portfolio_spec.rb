require 'rails_helper'

RSpec.describe Portfolio, type: :model do
  describe "associations" do
    it "belongs to a trader" do
      association = Portfolio.reflect_on_association(:trader)
      expect(association.macro).to eq(:belongs_to)
    end

    it "belongs to a stock" do
      association = Portfolio.reflect_on_association(:stock)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
