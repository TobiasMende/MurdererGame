class RenameDeletedAtInUser < ActiveRecord::Migration
  def change
    rename_column :users, :deletec_at, :deleted_at
  end
end
