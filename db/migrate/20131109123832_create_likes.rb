class CreateLikes < ActiveRecord::Migration
  def up
    create_table :likes do |t|
      t.integer :article_id
      t.string :user_id
      t.timestamps
    end
  end

  def down
  end
end
