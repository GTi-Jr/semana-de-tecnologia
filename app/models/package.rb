class Package < ActiveRecord::Base

  has_many :inscriptions, dependent: :restrict_with_error
  has_many :packages_events_types, dependent: :restrict_with_error
  has_many :users, through: :inscriptions, dependent: :restrict_with_error
  has_many :event_types, through: :packages_events_types, dependent: :restrict_with_error

  def remaining
    self.limit - self.inscriptions.count
  end

  def package_discount(current_user)
    package = self
    prices = Event.event_prices
    total_discount = 0

    if package_fit?(current_user)
      package.packages_events_types.each do |package_event_type|
        total_discount += prices[package_event_type.event_type.name]*package_event_type.limit
      end
    else
      total_discount = 0
    end
    total_discount
  end

  def package_fit?(current_user)
    count = Event.event_kind_count(current_user)
    package = self
    counter = 0
    package.packages_events_types.each do |package_event_type|
      name = package_event_type.event_type.name
      if count[name] >= package_event_type.limit
       counter +=1
      end
    end

    if counter == package.event_types.count
      true
    else
      false
    end
  end
end