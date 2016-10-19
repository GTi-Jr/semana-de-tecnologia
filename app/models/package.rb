class Package < ActiveRecord::Base

  has_many :inscriptions, dependent: :restrict_with_error
  has_many :packages_events_types, dependent: :destroy
  has_many :users, through: :inscriptions, dependent: :restrict_with_error
  has_many :event_types, through: :packages_events_types, dependent: :restrict_with_error

  def remaining
    self.limit - self.inscriptions.count
  end

  def package_discount(current_user)
    package = self
    prices = Event.event_prices
    total_discount = 0
    event_count = Event.event_kind_count(current_user)
     if package.package_fit?(current_user)
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
    count = Event.event_kind_count(current_user)
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
    package = self
    result = Hash.new 
    package.packages_events_types.each do |package_type|
      name = package_type.event_type.name
      result[name] = package_type.limit
    end
    result
  end

end