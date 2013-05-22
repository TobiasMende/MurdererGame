class AddFacebookidToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_identity, :integer, :limit => 8
  end
end
