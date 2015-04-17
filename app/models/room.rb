# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Room < ActiveRecord::Base
  attr_accessor :skip_name_validation
  has_many :timeslots, dependent: :destroy
  validates_presence_of :name
  validates :name, uniqueness: true, unless: :skip_name_validation
end
