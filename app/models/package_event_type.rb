class PackageEventType < ActiveRecord::Base
  belongs_to :event_type
  belongs_to :package
end