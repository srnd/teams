class Team < ActiveRecord::Base
	has_many :users
	belongs_to :event

	validates :name, :presence => true
	validates :event_id, :presence => true

	def api_filter
		return {:id => self.id, :name => self.name, :event_id => self.event_id, :project => self.project}
	end
end
