class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.integer :game_id
      t.integer :murderer_id
      t.integer :victim_id

      t.timestamps
    end
  end
end
