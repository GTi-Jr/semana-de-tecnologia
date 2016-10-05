class AssociationPackageEventType < ActiveRecord::Migration
  def change
  	add_reference :event_types, :package, index: true
  end
end
