class RenameTotalPriceToTotalAmountInTransactions < ActiveRecord::Migration[7.0]
  def change
    rename_column :transactions, :total_price, :total_amount
  end
end
