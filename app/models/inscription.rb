class Inscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :package

  validate :validate_limit, :validate_payment
  
  validates_uniqueness_of :user_id, scope: [:package_id]

  def check_limit
    self.package.remaining == 0 ? false : true
  end

  def validate_limit
    errors.add("Pacote", "está cheio.") unless check_limit
  end

  def validate_payment
    errors.add("Usuário","possui uma compra pendente.") if self.user.payment
  end
end