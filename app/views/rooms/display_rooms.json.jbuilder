
json.array! @rooms do |room|

json.extract!(room, :name)

json.timeslots room.timeslots, :id, :start_time, :end_time, :day


end
