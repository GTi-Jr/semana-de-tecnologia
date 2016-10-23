class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  has_one :payment
  has_many :purchases, foreign_key: :buyer_id, dependent: :destroy
  has_many :events, through: :purchases
  has_one :inscription, dependent: :destroy
  has_one :package, through: :inscription
  validates_associated :package

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates_date :birthday
  validates :birthday, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :course, presence: true, length: { maximum: 60 }
  validates :university, presence: true, length: { maximum: 70 }
  validates :semester, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates :password, length: { minimum: 6 }, on: :create

  validates :rg, presence: true, length: {
    in: 4..13,
    wrong_length: {
      other: 'não possui o tamanho esperado (%{count} dígitos)'
    }
  }, numericality: { only_integer: true }

  def cart_count
    self.events.count
  end

  def get_cart_events
   self.events
  end

  def purchase_cart_events!
    get_cart_events.each { |event| purchase(event) }
    $redis.del "cart#{id}"
  end

  def purchase(event)
    events << event unless purchase?(event)
  end

  def purchase?(event)
    events.include?(event)
  end

  def is_there_payment?
    self.payment.nil?
  end

  def is_there_package?
    self.try(:package).nil?
  end

  def events_kind_count
    events = self.events
    count = Hash.new
    kinds = Event.event_kinds
    kinds.each do |kind|
      count[kind] = 0
      events.each do |event|
        count[kind] +=1 if event.event_type.name == kind && event.price != 0
      end
    end
    count
  end

  def package_fit?
    count = self.events_kind_count
    package = self.package
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

  private
  def set_package
    flag = false
    if Package.count == 1
      self.package = Package.first
      flag = true
    elsif Package.count > 1
      flag = true
    end
    flag
  end
end
