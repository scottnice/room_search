if @rooms
  json.rooms @rooms do |room|
    json.extract!(room, :name)

    json.timeslots room.timeslots.starts_after(@time, @day), :id, :start_time, :end_time, :day
  end
end