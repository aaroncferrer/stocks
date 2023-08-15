class SetDefaultStatusForTraders < ActiveRecord::Migration[7.0]
  def change
    change_column_default :traders, :status, 'pending'
  end
end
