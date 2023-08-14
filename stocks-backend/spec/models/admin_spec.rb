require 'rails_helper'

RSpec.describe Admin, type: :model do
  it "is valid and saved" do
    admin = FactoryBot.build(:admin)
    expect(admin.save).to be true
  end

  it "is not saved because there's no name" do
    admin = FactoryBot.build(:admin, :without_name)
    expect(admin.save).to be false
  end

  it "is not saved because email is already taken" do
    existing_admin = FactoryBot.create(:admin)
    new_admin = Admin.new(first_name: "John", last_name: "Doe", email: existing_admin.email, password: "password", password_confirmation: "passowrd")

    expect(new_admin.save).to be false
  end

  it "is not saved because passwords don't match" do
    admin = Admin.new(first_name: "John", last_name: "Doe", email: "john@mail.com", password: "password", password_confirmation: "wrong_password")

    expect(admin.save).to be false
  end
end
