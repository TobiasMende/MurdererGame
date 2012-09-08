class ChangeDefaultForStartedInGames < ActiveRecord::Migration
  def change
    change_column_default(:games, :started, false)
  end
end
