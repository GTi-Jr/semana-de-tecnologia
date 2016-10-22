module Admin::PackagesHelper
  def package_date_field(form, date_field, attributes)
    if !@package[date_field]
      form.text_field date_field, attributes
    else
      form.text_field date_field, attributes.merge({ value: @package[date_field].strftime("%d/%m/%Y") })
    end
  end
end
