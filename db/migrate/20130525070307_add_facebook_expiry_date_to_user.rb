class AddFacebookExpiryDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_oauth_expires_at, :integer
  end
end
