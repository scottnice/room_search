json.array!(@timeslots) do |timeslot|
  json.extract! timeslot, :id, :start_time, :end_time, :day,, :references, :room_id
  json.url timeslot_url(timeslot, format: :json)
end
