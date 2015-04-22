require "rails_helper"

describe Timeslot do

it { should validate_presence_of :day }
it { should validate_presence_of :start_time }
it { should validate_presence_of :end_time }
it { should validate_presence_of :room_id }

it "should increase timeslots count by 1 when created" do

  expect {create(:timeslot)}.to change{Timeslot.all.count}.by(1)

end

it {should belong_to(:room)}

it "should have a valid day" do

  timeslot = build(:timeslot)

  Timeslot::DAYS.each do |day|
    timeslot.day = day
    expect(timeslot.valid?).to eql(true)
  end

end

end