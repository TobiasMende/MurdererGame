class RenameFacebookIdentityToId < ActiveRecord::Migration
  def change
    rename_column :users, :facebook_identity, :facebook_id
  end
end
