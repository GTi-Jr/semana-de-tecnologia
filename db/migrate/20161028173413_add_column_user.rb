class AddColumnUser < ActiveRecord::Migration
  def self.up
  	add_column :users, :rg, :string 
  end
end
