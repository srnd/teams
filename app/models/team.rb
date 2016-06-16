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

	def hook_slack(data = {})
		if self.slack_webhook_url
			data[:fallback] ||= "[CodeDay Teams attachment here]"
			data[:color] ||= "success"
			data[:fields] ||= []

			http_post("https://hooks.slack.com", URI(self.slack_webhook_url).path, JSON[data])
		end
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
			:event => self.event.api_filter,
			:project => self.project
		}
	end
end
