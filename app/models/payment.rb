class Payment < ActiveRecord::Base
	belongs_to :user

  validate :validate_payment_method, :validate_payment_status

  validate :validate_package

  validate :validate_purcharses, if: :have_package?

  before_validation :waiting, on: :create

  def accepted_payment_methods
    ['Depósito', 'Transferência', 'Presencial']
  end

  def accepted_payment_status
    ['Aguardando' ,'Pendente', 'Confirmado']
  end

  def waiting
    self.status = self.accepted_payment_status[0]
  end

  def pending
    self.status = self.accepted_payment_status[1]
    self.save
  end

  def paid
    self.status = self.accepted_payment_status[2]
    self.save
  end


  private
  def payment_method_is_valid?
    self.accepted_payment_methods.include? self.method
  end

  def payment_status_is_valid?
    self.accepted_payment_status.include? self.status
  end

  def have_package?
    self.user.package.nil? ? false : true
  end

  def validate_payment_method
    errors.add("Método de pagamento","é inválido.") unless payment_method_is_valid?
  end

  def validate_payment_status
    errors.add("Status do pagamento","é inválido.") unless payment_status_is_valid?
  end

  def validate_package
    errors.add("Nenhum pacote","foi selecionado.") unless have_package?
  end

  def validate_purcharses
    errors.add("Seu pacote","não está completo.") unless self.user.package_fit?
  end
end
