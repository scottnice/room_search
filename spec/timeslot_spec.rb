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

    timeslot.day = "SCRUMDAY"

    expect(timeslot.valid?).to eql(false)
  end

  it "start time should be before its endtime" do
    timeslot = build(:timeslot)
    # set end time to one hour before the start time should be invalid
    timeslot.end_time = timeslot.start_time - 1.hour

    expect(timeslot.valid?).to eql(false)
  end

  it "must be unique in the database" do
    timeslot = create(:timeslot).dup

    expect(timeslot.valid?).to eql(false)
  end

  it "must be able to update its self and can overlap it self" do
    timeslot = create(:timeslot).clone
    timeslot.start_time -= 1.hour

    expect(timeslot.valid?).to eql(true)
  end

  it "must be a minimum of one hour long" do
    timeslot = build(:timeslot)

    timeslot.end_time = timeslot.start_time + 45.minutes

    expect(timeslot.valid?).to eql(false)
  end

  context 'overlap' do
    let(:timeslot) { create(:timeslot).dup }

    before do
      timeslot.start_time -= 2.hours
      timeslot.end_time += 1.hours
    end

    it "will not be valid if overlapping on the same day and same time and same room" do
      expect(timeslot.valid?).to be_falsey
    end

    it "will be valid if on a different day" do
      timeslot.day = Timeslot::DAYS.reject{|day| day == timeslot.day}.first

      expect(timeslot.valid?).to be
    end

    it "will be valid if on a different room" do
      timeslot.room = create(:room, name: "somethingNew")

      expect(timeslot.valid?).to be
    end
  end
end