class AddOpenidToUser < ActiveRecord::Migration
  def change
    add_column :users, :openid_identity, :string
  end
end
