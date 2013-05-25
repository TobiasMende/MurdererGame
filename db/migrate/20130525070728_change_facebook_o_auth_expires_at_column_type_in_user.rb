class ChangeFacebookOAuthExpiresAtColumnTypeInUser < ActiveRecord::Migration
  def change
    change_column :users, :facebook_oauth_expires_at, :datetime
  end
end
