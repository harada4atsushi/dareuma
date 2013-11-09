class CreateArticles < ActiveRecord::Migration
  def up
    create_table :articles do |t|
      t.string :user_id
      t.integer :theme_id
      t.string :user_name
      t.text :content
      t.timestamps
    end
  end

  def down
  end
end
