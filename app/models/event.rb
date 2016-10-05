class Event < ActiveRecord::Base
  has_many :schedules, dependent: :restrict_with_error
  has_many :purchases, dependent: :restrict_with_error
  has_many :buyers, through: :purchases, dependent: :restrict_with_error

  validates_presence_of :name, :limit, :price
  validates_numericality_of :price, greater_than_or_equal_to: 0
  validates_associated :schedules, :purchases

  @@foo = 0

  def remaining
    self.limit - self.purchases.count
  end

  def self.events_prices
    lectures_price = self.find_by(kind:'palestra').price
    courses_price = self.find_by(kind:'mini-curso').price
    visits_price = self.find_by(kind:'visita').price
    price = Array.new
    price[0] = 0
    price[1] = 0
    price[2]=0

    price[0] += lectures_price
    price[1] += courses_price
    price[2] += visits_price

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
    count[:lectures] = 0
    count[:courses] = 0
    count[:visits] = 0
    events.each do |event|
      count[:lectures] +=1 if event.kind == 'palestra'
      count[:courses] +=1 if event.kind == 'mini-curso'
      count[:visits] +=1 if event.kind == 'visita'
    end
    count
  end

  def self.cart_total_price(current_user)
    total_price = 0
    partial_price = 0
    event_partial_price = 0
    current_user.get_cart_events.each { |event| event_partial_price += event.price }
    current_user.package ? partial_price = event_partial_price - current_user.package.package_discount(current_user) : partial_price = event_partial_price
    if current_user.package && current_user.package.package_fit?(current_user)
      total_price = current_user.package.price + partial_price
    else
      total_price = event_partial_price
    end
  end

  def circleColor
    if self.kind=="palestra"
      "purple"
    elsif self.kind == "mini-curso"

      "warning"
     elsif self.kind == "visita"
      "inverse"
    end
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
