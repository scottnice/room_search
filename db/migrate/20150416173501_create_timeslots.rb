class CreateTimeslots < ActiveRecord::Migration
  def change
    create_table :timeslots do |t|
      t.time :start_time
      t.time :end_time
      t.string :day

      t.timestamps
    end
  end
end
