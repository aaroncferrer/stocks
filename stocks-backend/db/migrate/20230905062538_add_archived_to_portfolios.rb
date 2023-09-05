class AddArchivedToPortfolios < ActiveRecord::Migration[7.0]
  def change
    add_column :portfolios, :archived, :boolean
  end
end
