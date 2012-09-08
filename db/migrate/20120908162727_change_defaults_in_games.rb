class ChangeDefaultsInGames < ActiveRecord::Migration
  def change
    change_column_default(:games, :description, "")
    change_column_default(:games, :assignment_start, Date.today)
    change_column_default(:games, :min_player, 0)
    change_column_default(:games, :max_player, 1000)
    change_column_default(:games, :needs_confirmation, false)
  end
end
