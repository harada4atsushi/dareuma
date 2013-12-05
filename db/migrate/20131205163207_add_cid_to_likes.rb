class AddCidToLikes < ActiveRecord::Migration
  def up
    add_column :likes, :cid, :string, :limit => 100
    rename_column :likes, :user_id, :twitter_uid
  end

  def down
    remove_column :likes, :cid
    rename_column :likes, :twitter_uid, :user_id
  end
end
