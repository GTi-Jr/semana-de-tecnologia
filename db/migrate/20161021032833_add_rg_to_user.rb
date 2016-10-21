class AddRgToUser < ActiveRecord::Migration
  def change
    add_column :users, :rg, :string, null: false, default: '00000000000'
  end
end
