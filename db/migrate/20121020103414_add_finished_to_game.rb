class AddFinishedToGame < ActiveRecord::Migration
  def change
    add_column :games, :finished, :boolean, :default => false
  end
end
