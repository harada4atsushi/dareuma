class AddProfileImageUrlToArticle < ActiveRecord::Migration
  def up
    add_column :articles, :profile_image_url, :string
  end

  def down
  end
end
