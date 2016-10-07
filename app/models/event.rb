class Event < ActiveRecord::Base
  has_many :schedules
  accepts_nested_attributes_for :schedules, :reject_if => lambda { |a| a[:start_time].blank? || a[:end_time].blank? }, :allow_destroy => true
  has_many :purchases
  has_many :buyers, through: :purchases
  belongs_to :event_type
  @@foo = 0

  def remaining
    self.limit - self.purchases.count
  end


  def self.event_kinds
     EventType.uniq.pluck(:name)
  end


  def self.event_prices
    kinds = Event.event_kinds
    price = Hash.new
    kinds.each do |kind|
      event_id = EventType.find_by(name:kind) 
      price[kind] = Event.find_by(event_type_id:event_id).price
    end

    price
  end

  def self.days
    days = []
    self.all.each do |event|
      event.schedules.each do |schedule|
        day = schedule.start_time.to_date
        days << day unless day.in?(days)
      end
    end
    days.sort!
  end

  def self.appointments
    scheduleDay = Hash.new
    days = self.days
    events = self.all
    days.each do |day|
      scheduleDay[day] = []
      events.each do |event|
        event.schedules.each do |schedule|
          scheduleDay[day] << schedule if schedule.start_time.to_date == day
          scheduleDay[day].sort_by! {|obj| obj.start_time}
        end
      end
    end
    scheduleDay
  end

  def self.appointment(my_events)
      scheduleDay = Hash.new
      days = Event.days
      events = my_events

      days.each do |day|
        scheduleDay[day] = []
        events.each do |event|
          event.schedules.each do |schedule|
            scheduleDay[day] << schedule if schedule.start_time.to_date == day
            scheduleDay[day].sort_by! {|obj| obj.start_time}
          end
        end
      end
      scheduleDay
  end
   #retorna os horários em ordem

  def self.timetables(eventsDay)
    timetables = []

    eventsDay.each do |event|
      event.schedules.each do |schedule|
        timetable = schedule.start_time
        timetables << timetable
      end
    end
    timetables
  end

  def self.event_kind_count(current_user)
    events = current_user.get_cart_events
    count = Hash.new
    kinds = Event.event_kinds
    kinds.each do |kind|
      count[kind] = 0
      events.each do |event|
        count[kind] +=1 if event.event_type.name == kind
      end

     
    end
    count
  end

  def self.cart_total_price(current_user)
    total_price = 0
    partial_price = 0
    event_partial_price = 0

    current_user.get_cart_events.each { |event| event_partial_price += event.price }
    
    current_user.package ? partial_price = event_partial_price - current_user.package.package_discount(current_user)
    : partial_price = event_partial_price

    if current_user.package && current_user.package.package_fit?(current_user)
      total_price = current_user.package.price + partial_price
    else
      total_price = event_partial_price
    end
  end

  def circleColor

      "inverse"
    
  end

  def sideAlt
  @@foo +=1
    if @@foo%2==0
      "timeline-item alt"
    else
      "timeline-item "
    end
  end

  def sideArrow
    if @@foo % 2 ==0
      "arrow-alt"
    else
      "arrow"
    end
  end

#final

  def cart_action(current_user_id)
   if $redis.sismember "cart#{current_user_id}", id
    "Remove from"
   else
    "Add to"
    end
  end

end
