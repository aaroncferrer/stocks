class Trader < ApplicationRecord
    has_many :transactions
    has_many :stocks, through: :transactions
    has_many :portfolios

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, confirmation: true, on: :create

    has_secure_password

    enum status: { pending: "pending", approved: "approved" }

    validate :unique_email_across_models, on: :create

    def deposit(amount)
        self.balance += amount
        save
    end

    def withdraw(amount)
        return false if amount <= 0 || balance < amount

        self.balance -= amount
        save
    end

    private

    def unique_email_across_models
        if Admin.exists?(email: email) || Trader.exists?(email: email)
            errors.add(:email, 'is already taken')
        end
    end
end
