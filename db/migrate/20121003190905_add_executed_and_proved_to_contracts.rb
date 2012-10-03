class AddExecutedAndProvedToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :executed_at, :datetime
    add_column :contracts, :proved_at, :datetime
  end
end
