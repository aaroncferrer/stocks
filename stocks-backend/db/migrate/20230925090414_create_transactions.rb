class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :trader, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.string :action
      t.integer :quantity
      t.float :total_price
      t.string :stock_symbol

      t.timestamps
    end
  end
end
