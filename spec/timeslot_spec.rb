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

  context 'after' do
    let(:monday) { Timeslot::DAYS.first }
    let(:before_timeslot) { create(:timeslot, start_time: Time.now - 2.hours, end_time: Time.now - 1.hours, day: monday) }
    let(:after_timeslot) { create(:timeslot, start_time: Time.now + 1.hours, end_time: Time.now + 2.hours, day: monday) }
    let(:in_between_timeslot) { create(:timeslot, start_time: Time.now - 1.hour, end_time: Time.now + 1.hour, day: monday) }

    context 'starts_after' do
      it "gets all timeslots starts after now" do
        expect(Timeslot.starts_after(Time.now, monday)).to include(after_timeslot)
      end

      it "gets no timeslots before now" do
        expect(Timeslot.starts_after(Time.now, monday)).not_to include(before_timeslot)
      end

      it "does not get overlapping timeslots" do
        expect(Timeslot.starts_after(Time.now, monday)).not_to include(in_between_timeslot)
      end
    end

    context 'ends_after' do
      it "gets all timeslots ends after now" do
        expect(Timeslot.ends_after(Time.now, monday)).to include(after_timeslot)
      end

      it "gets no timeslots that end before now" do
        expect(Timeslot.ends_after(Time.now, monday)).not_to include(before_timeslot)
      end

      it "does get timeslots that end after" do
        expect(Timeslot.ends_after(Time.now, monday)).to include(in_between_timeslot)
      end
    end

    context 'starts_before_ends_after' do
      it "should not get any time slots that start and end after" do
        expect(Timeslot.starts_before_ends_after(Time.now, monday)).not_to include(after_timeslot)
      end

      it "gets no timeslots that start and end before now" do
        expect(Timeslot.starts_before_ends_after(Time.now, monday)).not_to include(before_timeslot)
      end

      it "does get timeslots that start before and end after" do
        expect(Timeslot.starts_before_ends_after(Time.now, monday)).to include(in_between_timeslot)
      end
    end

  end



  # context 'find not between' do
  #   it "should not find any in between given dates" do
  #     monday = Timeslot::DAYS.first

  #     create(:timeslot, start_time: Time.now - 5.hours, end_time: Time.now - 4.hours, day: monday)

  #     expect(Timeslot.notBetween(Time.now, monday)).to be_nil
  #   end

  # end

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