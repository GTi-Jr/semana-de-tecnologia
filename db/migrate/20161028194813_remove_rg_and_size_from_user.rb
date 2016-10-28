class RemoveRgAndSizeFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :rg, :string
    remove_column :users, :size, :string
  end
end
