class EventType < ActiveRecord::Base
	belongs_to :package
	has_many :events, dependent: :restrict_with_error
end
