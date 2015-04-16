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
  validates_uniqueness_of :id, scope: [:day, :room_id, :start_time, :end_time]

  validates_presence_of :day, :start_time, :end_time, :room_id
  validate :check_if_date_comes_before

  private

  def check_if_date_comes_before
    if start_time and end_time
      if start_time <= end_time
        errors.add(:start_time, "must be before end date.")
        return false
      end
      return true
    end
  end

end
