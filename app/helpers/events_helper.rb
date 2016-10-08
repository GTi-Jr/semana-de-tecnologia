module EventsHelper
  def event_types_to_array
    event_types_array = [
      ['Selecione', nil]
    ]

    EventType.all.each do |event_type|
      event_types_array << [event_type.name, event_type.id]
    end

    event_types_array
  end
end
