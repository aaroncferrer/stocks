class AddBalanceToTraders < ActiveRecord::Migration[7.0]
  def change
    add_column :traders, :balance, :float, default: 500.00
  end
end
