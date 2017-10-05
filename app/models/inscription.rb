class Inscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :package

  validate :validate_limit, :validate_payment

  validates_uniqueness_of :user_id, scope: [:package_id]

  def is_full?
    #self.package.remaining <= 0 ? false : true
    self.package.inscriptions.count >= self.package.limit 
  end

  def validate_limit
    errors.add("Pacote", "está cheio.") if is_full?
  end

  def validate_payment
    errors.add("Usuário","possui uma compra pendente.") if self.user.payment
  end
end
