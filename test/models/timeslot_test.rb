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

require 'test_helper'

class TimeslotTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "time slots must have data" do
    time = Timeslot.new
    assert time.invalid?, "timeslots with nil data shouldnt be valid"
    assert time.errors[:day].any?, "invalid time slots should have errors"
    assert time.errors[:room_id].any?, "invalid time slots should have errors"
    assert time.errors[:end_time].any?, "invalid time slots should have errors"
    assert time.errors[:start_time].any?, "invalid time slots should have errors"

  end

  test "day of the week must be valid" do
    time = timeslots(:one)
    time.day = "SCUMDAY"

    assert time.invalid?, "Must be a day of the week to be valid"

    time.day = "SUNDAY"
    assert time.valid?, "The day #{time.day} should be valid"

  end

  test "start time must be before end time" do
    time = timeslots(:one)
    time.end_time -= 4.hours
    assert time.invalid?, "Start time must be before end time"
  end

  test "each timeslot must be unique" do
    time = Timeslot.first

    new_timeslot = Timeslot.new(time.attributes.reject{|k, _| k == "id"})

    assert new_timeslot.invalid?, "Time slot must be unique"
  end

  test "each timeslot is minimum of one hour" do
    time = timeslots(:one)
    time.end_time = time.start_time + 45.minutes
    time.day = "SUNDAY"

    assert time.invalid?, "each time slot is a minimum of one hour start hour #{time.start_time.hour} end hour #{time.end_time.hour}"
  end

  test "that timeslots cant overlap" do
    time = Timeslot.first
    time2 = Timeslot.new(time.attributes.reject{|k, _| k == "id"})

    time2.start_time -= 5.hours


    assert time2.invalid?, "Times shouldn't overlap This #{time.start_time} #{time.end_time} overlaps with this #{time2.start_time} #{time2.end_time}"

  end
end
