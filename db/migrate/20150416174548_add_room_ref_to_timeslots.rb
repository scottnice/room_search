class AddRoomRefToTimeslots < ActiveRecord::Migration
  def change
    add_reference :timeslots, :room, index: true
  end
end
