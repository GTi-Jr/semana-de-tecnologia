class Inscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :package

  validate :validate_limit, :validate_payment, :validate_date_range

  validates_uniqueness_of :user_id, scope: [:package_id]

  def validate_date_range
    errors.add("Pacote","está encerrado.") unless valid_dates.include? Date.today
  end

  def validate_limit
    errors.add("Pacote", "está cheio.") unless check_limit
  end

  def validate_payment
    errors.add("Usuário","possui uma compra pendente.") if self.user.payment
  end

  def check_limit
    self.package.remaining <= 0 ? false : true
  end

  def valid_dates
    (self.package.opening_date..self.package.closure_date).to_a
  end
end
