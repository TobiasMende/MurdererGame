class AddDeletedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :deletec_at, :datetime
  end
end
