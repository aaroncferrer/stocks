class Trader < ApplicationRecord
    has_many :transactions
    has_many :stocks, through :transactions
    has_many :portfolios

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, confirmation: true

    has_secure_password

    enum status: { pending: "pending", approved: "approved" }
end
