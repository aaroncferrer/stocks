class RenameTotalValueToTotalAmount < ActiveRecord::Migration[7.0]
  def change
    rename_column :portfolios, :total_value, :total_amount
  end
end
