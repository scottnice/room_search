require "rails_helper"

describe Room do

  it { should validate_presence_of :name }
  it {should have_many :timeslots}

  it "needs data" do
    room = Room.new
    expect(room.valid?).to eql(false)
  end

  it "needs a unique name" do
    room = create(:room).dup
     expect(room.valid?).to eql(false)
  end

end
