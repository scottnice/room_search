# == Schema Information
#
# Table name: timeslots
#
#  id         :integer          not null, primary key
#  start_time :time
#  end_time   :time
#  day        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  room_id    :integer
#

class Timeslot < ActiveRecord::Base
  belongs_to :room

  DAYS = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY']
  validates_uniqueness_of :room_id, scope: [:day, :room_id, :start_time, :end_time]

  validates_presence_of :day, :start_time, :end_time, :room_id
  validate :check_if_date_comes_before
  validate :check_if_day_is_valid
  validate :time_slot_atleast_one_hour
  validate :time_slots_dont_overlap

  private

  def check_if_date_comes_before
    if start_time and end_time
      if start_time >= end_time
        errors.add(:start_time, "must be before end date.")
        return false
      end
      return true
    end
  end

  def check_if_day_is_valid
    if day
      if !DAYS.include?(day)
        errors.add(:day, "must be either " + DAYS.join(","))
        return false
      else
        return true
      end
    end
  end

  def time_slot_atleast_one_hour
    if start_time and end_time
      if (end_time.hour - start_time.hour) < 1
        errors.add(:end_time, "must be atleast an hour after start time.")
        false
      else
        true
      end
    end
  end

  def time_slots_dont_overlap
    times = Timeslot.where(day: day).to_a
    times.each do |atime|
      if overlaps?(atime, self) and atime.id != id
        errors.add(:start_time, "Times cannot overlap")
        return false
      end
    end
    return true
  end

  def overlaps?(x, y)
    (x.start_time - y.end_time) * (y.start_time - x.end_time) > 0
  end

end
