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
  validate :time_slots_dont_overlap, :on => [:create, :update]

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
    times = Timeslot.where(day: day, room_id: room_id).where.not(id: self.id)
    times.each do |atime|
      puts "OVERLAYS:::#{overlaps?(atime, self)}, #{atime.inspect}, #{self.inspect}"
      if overlaps?(atime, self)
        errors.add(:start_time, "Times cannot overlap #{atime.inspect}")
        return false
      end
    end
    return true
  end

  def overlaps?(time_slot1, time_slot2)
    slot1Start = convertTimeToMinutes(time_slot1.start_time)
    slot1End = convertTimeToMinutes(time_slot1.end_time)
    slot2Start = convertTimeToMinutes(time_slot2.start_time)
    slot2End = convertTimeToMinutes(time_slot2.end_time)

    (slot1Start - slot2End) * (slot2Start - slot1End) > 0

  end

  def convertTimeToMinutes(time)
    time.hour * 60 + time.min
  end

end
