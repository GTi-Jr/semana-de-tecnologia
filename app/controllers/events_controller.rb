class EventsController < ProfileController
  def index
    @events = Event.all
    @eventsDays = Event.days
    @scheduleHash = Event.appointments
    @my_events = @user.events
    @my_events_day = Event.appointment(@my_events)
    @number = 0
  end
end
