require 'jwt_auth'

class Admin::TradersController < ApplicationController
    before_action :require_admin
    
    def index
        traders = pending_traders(params[:status])
        render json: traders
    end

    def show
        trader = Trader.find(params[:id])
        render json: trader
    end

    def create
        trader = Trader.new(trader_params)

        if trader.status == "approved"
            trader.confirmed_at = Time.current
        end

        if trader.save
            render json: trader, status: :created
        else
            render json: { errors: trader.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        trader = Trader.find(params[:id])
        if trader.update(trader_params)
            render json: trader
        else 
            render json: { errors: trader.errors.full_messages }, status: :unprocessable_entity
        end
    end 

    private

    def trader_params
        params.require(:trader).permit(:first_name, :last_name, :email, :password, :password_confirmation, :status)
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
