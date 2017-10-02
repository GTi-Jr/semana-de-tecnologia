class AddCelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cel, :string
  end
end
