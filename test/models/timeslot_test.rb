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

    days = ['MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY']

  end

  test "Start time cant be after 10pm" do
    time = timeslots(:two)

    assert time.invalid?, "Start time must be before end time"
  end
=begin
  test "start time must be before end time" do

  end

  test "each timeslot must be unique" do

  end

  test "each timeslot is minimum of one hour" do
  end

  test "each timeslot starts and ends at 10 minutes after" do
  end
=end
end
