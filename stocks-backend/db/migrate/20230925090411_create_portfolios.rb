class CreatePortfolios < ActiveRecord::Migration[7.0]
  def change
    create_table :portfolios do |t|
      t.references :trader, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.integer :quantity
      t.float :current_price
      t.float :total_amount
      t.string :stock_symbol
      t.boolean :archived

      t.timestamps
    end
  end
end
