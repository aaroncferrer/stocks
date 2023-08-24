class DropTransactionsAndPortfolios < ActiveRecord::Migration[7.0]
  def change
    drop_table :transactions
    drop_table :portfolios
  end
end
