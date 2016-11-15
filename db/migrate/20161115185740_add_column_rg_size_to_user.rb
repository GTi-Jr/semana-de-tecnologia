class AddColumnRgSizeToUser < ActiveRecord::Migration
  def self.up
  	add_column :users, :size, :string
  	add_column :users, :rg, :string 
  end
  def self.down
  	remove_column :users, :size
  	add_column :users, :rg 
  	
  end
end
