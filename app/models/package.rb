class Package < ActiveRecord::Base

  has_many :inscriptions
  has_many :users, through: :inscriptions
  has_many :event_types

  def remaining
    self.limit - self.inscriptions.count
  end

  def package_discount(current_user)
    package = self
    prices = Event.events_prices
    total_discount = 0
    if package_fit?(current_user)
      package.event_types.each do |type|
      total_discount += prices[type.name]*type.limit 
    end
  end
end

  def package_fit?(current_user)
    count = Event.event_kind_count(current_user)
    package = self
    count = 0
    package.event_types.each do |type|
      if count[type.name] >= type.limit
     
       count +=1
      end
    end

    if count == package.event_types.count
      true
    else
      false
end
end
end