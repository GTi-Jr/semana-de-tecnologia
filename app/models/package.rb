class Package < ActiveRecord::Base

  has_many :inscriptions, dependent: :restrict_with_error
  has_many :packages_events_types, dependent: :destroy
  has_many :users, through: :inscriptions, dependent: :restrict_with_error
  has_many :event_types, through: :packages_events_types, dependent: :restrict_with_error

  validates_presence_of :title, :limit, :price

  def remaining
    self.limit - self.inscriptions.count
  end

  def package_discount(current_user)
    package = self
    prices = Event.event_prices
    total_discount = 0
    event_count = current_user.events_kind_count
     if current_user.package_fit?
        package.packages_events_types.each do |package_event_type|
          total_discount += prices[package_event_type.event_type.name]*package_event_type.limit
        end
     else
      package.packages_events_types.each do |package_event_type|
         if event_count[package_event_type.event_type.name] >= package_event_type.limit
            total_discount += prices[package_event_type.event_type.name]*  package_event_type.limit
         else
          total_discount+=0
        end
      end
   end

    total_discount
  end

  def plus(current_user)
    package = self.event_out(current_user)
    prices = Event.event_prices
    result = 0
    package.keys.each do |type|
      result += package[type] * prices[type]
    end
    result
   end

  def event_out(current_user)
    count = current_user.events_kind_count
    package = self.kind_count
    counter = 0
    result = Hash.new
    count.keys.each do |type|

      result[type] = 0
      if !package[type].nil?
        counter = count[type] - package[type]
        if counter > 0
          result[type] = counter
        end
      else
        result[type] = count[type]
      end
    end
    result
  end

  def kind_count
    result = Hash.new
    self.packages_events_types.each do |package_type|
      name = package_type.event_type.name
      result[name] = package_type.limit
    end
    result
  end

end
