class Team < ActiveRecord::Base
	has_and_belongs_to_many :users
	has_many :awards
	belongs_to :batch
	belongs_to :event

	validates :name, :presence => true
	validates :event_id, :presence => true

	def api_filter
		return {
			:id => self.id,
			:name => self.name,
			:event_id => self.event_id,
			:project => self.project
		}
	end
end
