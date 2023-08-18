class Admin < ApplicationRecord
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, confirmation: true

    has_secure_password

    validate :unique_email_across_models, on: :create

    private

    def unique_email_across_models
        if Admin.exists?(email: email) || Trader.exists?(email: email)
            errors.add(:email, 'is already taken')
        end
    end
end
