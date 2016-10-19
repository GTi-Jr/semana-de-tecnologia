class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :cpf, :string, null: false, default: "00000000000"
    add_column :users, :rg, :string, null: false, default: "00000000000"
    add_column :users, :size, :string, null: false, default: "M"
  end
end
