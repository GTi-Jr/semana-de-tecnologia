class PackageEventType < ActiveRecord::Base
  belongs_to :event_type
  belongs_to :package

  validates_presence_of :event_type_id, :package_id, :limit

  validates_uniqueness_of :event_type_id, scope: [:package_id]
end