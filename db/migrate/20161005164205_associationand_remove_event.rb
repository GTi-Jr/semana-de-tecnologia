class AssociationandRemoveEvent < ActiveRecord::Migration
  def self.up
  	add_reference :events, :event_type, index:true
  end
end
