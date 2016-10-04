module Admin::SchedulesHelper
  def schedule_time_field(form, time_field, attributes)
    if !@schedule[time_field]
      form.text_field time_field, attributes
    else
      form.text_field time_field, attributes.merge({ value: @schedule[time_field].strftime("%d/%m/%Y %H:%M") })
    end
  end
end