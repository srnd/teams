class Team < ActiveRecord::Base
	has_and_belongs_to_many :users
	has_and_belongs_to_many :tags
	has_many :awards
	belongs_to :batch
	belongs_to :event

	validates :name, :presence => true, :length => { maximum: 25 }
	validates :short_description, :presence => true, :length => { maximum: 75 }
	# validates_url_format_of :youtube_url
	validates :event_id, :presence => true
	# validates :slack_webhook_url, :format => {:with => URI.regexp}

	def team_photo
		if self.team_photo_url && self.team_photo_url != ""
			self.team_photo_url
		else
			"http://cdn.pcwallart.com/images/gradient-background-wallpaper-4.jpg" # TODO host locally
		end
	end

	def tags_as_hashtags
		hashtags = ""

		self.tags.each do |tag|
			hashtags += "\##{tag.as_hashtag} "
		end

		hashtags
	end

	def extra_rendered
		$markdown.render(self.extra || "")
	end

	def description_rendered
		$markdown.render(self.project_description)
	end

	def api_filter
		{
			:id => self.id,
			:name => self.name,
			:event => self.event.api_filter
		}
	end
end
