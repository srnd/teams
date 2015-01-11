class Team < ActiveRecord::Base
	has_many :users
	belongs_to :event

	validates :name, :presence => true
	validates :event_id, :presence => true
end
