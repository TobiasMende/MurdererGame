class RenameOpenidIdentityInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :openid_identity, :openid_url
  end
end
