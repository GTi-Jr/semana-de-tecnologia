class AddRgAndSizeToUser < ActiveRecord::Migration
  def change
    add_column :users, :rg, :string
    add_column :users, :size, :string
  end
end
