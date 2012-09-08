class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :state
      t.boolean :accepted

      t.timestamps
    end
  end
end
