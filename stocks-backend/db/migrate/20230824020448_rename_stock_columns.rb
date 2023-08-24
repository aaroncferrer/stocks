class RenameStockColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :stocks, :price, :price_amount
    rename_column :stocks, :currency, :price_currency
  end
end
