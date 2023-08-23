class RenameTotalAmountToTotalPriceInTransactions < ActiveRecord::Migration[7.0]
  def change
    rename_column :transactions, :total_amount, :total_price
  end
end
