module TimeslotsHelper
  def day_options
    Timeslot::DAYS.map{|day| [day.capitalize, day] }
  end

  def room_options
    Room.all.collect{ |r| [r.name, r.id]}
  end

  def time_diff_hours(timeslot)
    pluralize(timeslot.time_difference_in_hours.truncate, "hour")
  end

  def time_diff_min(timeslot)
    if timeslot.time_difference_in_mins > 0
      pluralize(timeslot.time_difference_in_mins.truncate, "minute")
    end
  end

  def hour_minute(timeslot)
    "#{time_diff_hours(timeslot)} #{time_diff_min(timeslot)}"
  end
end