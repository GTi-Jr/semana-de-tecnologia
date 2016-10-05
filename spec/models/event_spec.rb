
require 'rails_helper' 
describe Event do 
 
before(:each) do
	@event1 = FactoryGirl.create(:event)
	@event2 = FactoryGirl.create(:event)
	@event3 = FactoryGirl.create(:event)
	@event4 = FactoryGirl.create(:event)
	#@event1.schedules.create(Schedule.create(start_time: DateTime.new(2016,6,10)))
	#@event2.schedules.create(FactoryGirl.create(:schedule))
	#@event3.schedules.create(FactoryGirl.create(:schedule))
	#@event4.schedules.create(FactoryGirl.create(:schedule))
end




it "returns even numbers" do

	#days =  event.days
	@event1.schedules.create(start_time:DateTime.new(2016,5,10))
	@event1.schedules.create(start_time:DateTime.new(2016,5,12))
	@event2.schedules.create(start_time:DateTime.new(2016,5,12))
	@event3.schedules.create(start_time:DateTime.new(2016,5,8))
	@event4.schedules.create(start_time:DateTime.new(2016,5,9))
	 
	event = Event.appointments 
	
  days = Event.days
expect(event).to eql(DateTime.new(2016,5,10))
end


it "returns events_types" do
	kinds = Event.event_kinds

	expect(kinds).to eql('amor')
end

end


