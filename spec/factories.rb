FactoryGirl.define do

  factory :room do
    name "test"
  end

  factory :timeslot do
    start_time "12:00:00"
    end_time "13:00:00"
    day "MONDAY"
    room
  end

end