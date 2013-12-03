class AddTwitterUidToArticles < ActiveRecord::Migration
  def up
    add_column :articles, :twitter_uid, :integer, :limit => 8
    remove_column :articles, :user_id
  end

  def down
    remove_column :articles, :twitter_uid
    add_column :articles, :user_id, :string
  end
end
