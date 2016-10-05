class RemoveColumnsPackage < ActiveRecord::Migration
  def self.up
  	remove_column :packages, :visits
    remove_column :packages, :courses
    remove_column :packages, :lectures  	
  end
  
end
