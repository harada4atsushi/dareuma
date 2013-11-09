class CreateThemes < ActiveRecord::Migration
  def up
    create_table :themes do |t|
      t.string :subject
      t.timestamps
    end
  end

  def down
  end
end
