require 'jwt_auth'

class Admin::TradersController < ApplicationController
    before_action :require_admin
    
    def index
        status = params[:status]
        traders = filtered_traders(status).order(id: :desc)
        render json: traders
    end

    def show
        trader = Trader.find(params[:id])
        render json: trader
    end

    def create
        trader = Trader.new(trader_params.merge(status: 'approved', confirmed_at: Time.current))

        if trader.save
            TraderMailer.account_creation_notification(trader).deliver_now
            render json: trader, status: :created
        else
            render json: { errors: trader.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        trader = Trader.find(params[:id])
        if trader.update(trader_params)
            if trader.approved?
                trader.update(confirmed_at: Time.current)
                TraderMailer.approval_notification(trader).deliver_now
            elsif trader.pending?
                trader.update(confirmed_at: nil)
                TraderMailer.account_hold_notification(trader).deliver_now
            end

            render json: trader
        else 
            render json: { errors: trader.errors.full_messages }, status: :unprocessable_entity
        end
    end 

    private

    def filtered_traders(status)
        case status
        when 'pending'
            Trader.where(status: 'pending')
        when 'approved'
            Trader.where(status: 'approved')
        else
            Trader.all
        end
    end

    def trader_params
        params.require(:trader).permit(:first_name, :last_name, :email, :password, :password_confirmation, :status, :balance)
    end

    def pending_traders(status = nil)
        if status.present?
            Trader.where(status: status)
        else
            Trader.all
        end
    end

    def require_admin
        unless @current_user.is_a?(Admin)
            render json: { error: 'Only admin users are allowed to perform this action' }, status: :forbidden
        end
    end
end
