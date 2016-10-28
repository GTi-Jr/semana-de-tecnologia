class AddColumnToUser < ActiveRecord::Migration
  def self.up 
  	add_column :users, :size, :string 
  end
end
