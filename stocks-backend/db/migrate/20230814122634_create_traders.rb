class CreateTraders < ActiveRecord::Migration[7.0]
  def change
    create_table :traders do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :status
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
