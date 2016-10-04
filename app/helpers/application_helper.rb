module ApplicationHelper
  def current_week
    # case Rails.application.secrets.week_id
    # when "semana_test"
    #   @week = {
    #     name: 'Semana em Teste',
    #     sigla: 'SeT',
    #     colors: { primary: '#871328', default: '#FFFFFF' },
    #     logo: 'semana_test-logo.png',
    #     avatar: '',
    #     infos: { conta: '2253-5', agencia: '42324-6', beneficiado: 'Rodrigo Teixeira noronha', banco: 'Banco do Brasil', local: 'Casa do Chico' }
    #   }
    # when "stem"
    #   @week = {
    #     name: 'Semana de Tecnologia da Engenharia Mecânica',
    #     sigla: 'STEM',
    #     colors: [primary: '#871328'],
    #     logo: 'stem-logo.png',
    #     avatar: 'stem-avatar.png',
    #     infos: { conta: '2253-5', agencia: '42324-6', beneficiado: 'Rodrigo Teixeira noronha', banco: 'Banco do Brasil', local: 'Casa do Chico' }
    #   }
    # when "sec"
    #   @week = {
    #     name: 'Semana da Engenharia Civil',
    #     sigla: 'SEC',
    #     colors: [base: '#FFFFFF'],
    #     logo: 'sec-logo.png',
    #     infos: { conta: '2253-5', agencia: '42324-6', beneficiado: 'Rodrigo Teixeira noronha', banco: 'Banco do Brasil', local: 'Casa do Chico' }
    #   }
    # when "setic"
    #   @week = {
    #     name: 'Semana de Tecnologia e Inovação',
    #     sigla: 'Setic', colors: [base: '#FFFFFF'],
    #     logo: 'setic-logo.png',
    #     infos: { conta: '2253-5', agencia: '42324-6', beneficiado: 'Rodrigo Teixeira noronha', banco: 'Banco do Brasil', local: 'Casa do Chico' }
    #   }
    # else
    #   @week = { infos: { conta: '2253-5', agencia: '42324-6', beneficiado: 'Rodrigo Teixeira noronha', banco: 'Banco do Brasil', local: 'Casa do Chico' } }
    # end

    config = YAML.load_file("#{Rails.root.to_s}/config/weeks.yml")

    config[Rails.application.secrets.week_id].deep_symbolize_keys
  end

  def flash_class(level)
    case level
        when 'notice' then "alert alert-dismissable alert-info"
        when 'success' then "alert alert-dismissable alert-success"
        when 'error' then "alert alert-dismissable alert-danger"
        when 'alert' then "alert alert-dismissable alert-danger"
    end
  end

  def time_pt(dt)
    dt.strftime("%d/%m/%Y às %H:%M")
  end

  def payment_status(status)
    status ? 'Pago' : 'Pendente'
  end
end
