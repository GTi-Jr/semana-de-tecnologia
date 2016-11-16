module ApplicationHelper
  def current_week
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

  def date_pt(d)
    if !d.nil?
      d.strftime("%d/%m/%Y")
    else
      '--'
    end
  end

  def time_pt(dt)
    dt.strftime("%d/%m/%Y às %H:%M")
  end

  def payment_status(status)
    status ? 'Pago' : 'Pendente'
  end

  def human_models custom_controller_path = controller_path
    if %w( teams members ).include? custom_controller_path
      custom_controller_path = "challenge/#{custom_controller_path}"
    end
    custom_controller_path.classify.constantize.model_name.human count: 2
  end

  def human_model custom_controller_path = controller_path
    custom_controller_path.classify.constantize.model_name.human
  end

  def titulo_pagina custom_controller_path = controller.controller_name
    titulos = {
      index: -> () { "Listando #{human_models custom_controller_path}" },
      show: -> () { "Visualizando #{human_model custom_controller_path}" },
      new: -> () { "Cadastrando #{human_model custom_controller_path}" },
      edit: -> () { "Editando #{human_model custom_controller_path}" }
    }

    titulos[action_name.to_sym].try(:call) || "#{custom_controller_path}##{action_name}"
  end

  def action_text custom_controller_path = controller.controller_name
    "Salvar #{human_model custom_controller_path}"
  end

  def sizes_to_array
    sizes_array = [
      ['Selecione', nil],
      ['P'],
      ['M'],
      ['G'],
      ['GG']
    ]
  end

  def to_date_field(form, resource, date_field, attributes)
    if !resource[date_field]
      form.text_field date_field, attributes
    else
      form.text_field date_field, attributes.merge({ value: resource[date_field].strftime("%d/%m/%Y") })
    end
  end
end
