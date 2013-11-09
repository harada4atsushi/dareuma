class RenameColumnArticleImage < ActiveRecord::Migration
  def up
    rename_column :articles, :profile_image_url, :image
  end

  def down
  end
end
