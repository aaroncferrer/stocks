class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :symbol
      t.string :currency
      t.float :price
      t.float :percent_change
      t.integer :volume
      t.datetime :as_of

      t.timestamps
    end
  end
end
