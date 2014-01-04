class AddOrderDateToThemes < ActiveRecord::Migration
  def up
    add_column :themes, :order_date, :date
  end

  def down
    remove_column :themes, :order_date
  end
end
