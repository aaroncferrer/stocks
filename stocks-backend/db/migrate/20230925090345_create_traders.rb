class CreateTraders < ActiveRecord::Migration[7.0]
  def change
    create_table :traders do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :status, default: 'pending'
      t.datetime :confirmed_at
      t.float :balance, default: 500.0

      t.timestamps
    end
  end
end
