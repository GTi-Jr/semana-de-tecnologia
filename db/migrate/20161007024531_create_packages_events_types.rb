class CreatePackagesEventsTypes < ActiveRecord::Migration
  def change
    create_table :packages_events_types do |t|
      t.integer :event_type_id, null: false
      t.integer :package_id, null: false
      t.integer :limit, null: false, default: 0

      t.timestamps null: false
    end

    add_index :packages_events_types, [:event_type_id, :package_id], unique: true
  end
end
