class AddColumnsToPackage < ActiveRecord::Migration
  def change
    add_column :packages, :opening_date, :date, null: false, default: Date.today
    add_column :packages, :closure_date, :date, null: false, default: Date.tomorrow
  end
end
