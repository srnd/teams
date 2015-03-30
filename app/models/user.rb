class User < ActiveRecord::Base
	has_and_belongs_to_many :teams
	has_many :tokens
	belongs_to :event
	validates :username, uniqueness: true, presence: true
	validates :username, :format => { :with => /[a-z0-9]+[-a-z0-9]*[a-z0-9]+/i }

	before_save :default_values

	def default_values
		self.admin ||= false
		self.generate_salt
	end

	def authenticate(password)
		if Digest::MD5.hexdigest(Digest::MD5.hexdigest(password) + self.salt) == self.password
			true
		else
			false
		end
	end

	def generate_salt
		if self.salt == nil
			random_string = SecureRandom.urlsafe_base64(8)
			self.update(:salt => random_string)
		end
	end

	def current_team
		self.teams.where(:batch_id => Batch.where(:current => true).first.id).first
	end

	def set_password(password)
		if self.salt == nil
			self.generate_salt
		end
		self.update(:password => Digest::MD5.hexdigest(Digest::MD5.hexdigest(password) + self.salt))
	end

	def api_filter
		{
			:id => self.id,
			:username => self.username,
			:name => self.name,
			:admin => self.admin,
			:team => self.team
		}
	end
end
