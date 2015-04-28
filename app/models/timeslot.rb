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

  DAYS = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'].freeze

  validates_uniqueness_of :room_id, scope: [:day, :room_id, :start_time, :end_time]

  validates_presence_of :day, :start_time, :end_time, :room_id
  validate :check_if_date_comes_before, if: ->() { start_and_end_time_present? }
  validate :check_if_day_is_valid
  validate :time_slot_atleast_one_hour, if: ->() { start_and_end_time_present? }
  validate :time_slots_dont_overlap, on: [:create, :update]

  def time_difference_in_hours
    @hours ||= ((end_time - start_time) / 3600)
  end

  def time_difference_in_mins
    hours = time_difference_in_hours

    ((hours - hours.truncate) * 60)
  end

  private

  def check_if_date_comes_before
    errors.add(:start_time, "must be before end date.") if start_time >= end_time
  end

  def check_if_day_is_valid
    errors.add(:day, "must be either " + DAYS.join(",")) unless DAYS.include?(day)
  end

  def time_slot_atleast_one_hour
    errors.add(:end_time, "must be atleast an hour after start time.") if (end_time.hour - start_time.hour) < 1
  end

  def time_slots_dont_overlap
    times = Timeslot.where(day: day, room_id: room_id).where.not(id: id)

    times.each do |atime|
      if overlaps?(atime, self)
        errors.add(:start_time, "Times cannot overlap, your time is overlapping with #{atime.start_time.strftime("%H:%M")} -
                                #{atime.end_time.strftime("%H:%M")}")
      end
    end
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

  def start_and_end_time_present?
    start_time.present? and end_time.present?
  end

end