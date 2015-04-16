# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "room needs data" do
    room = Room.new
    assert room.invalid?, "Room is valid when it should be invalid"
    assert room.errors[:name].any?, "Room should have error messages"
  end
end
