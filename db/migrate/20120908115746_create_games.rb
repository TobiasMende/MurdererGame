class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :title
      t.text :description
      t.date :assignment_start
      t.date :assignment_end
      t.date :game_start
      t.date :game_end
      t.integer :min_player
      t.integer :max_player
      t.boolean :needs_confirmation

      t.timestamps
    end
  end
end
