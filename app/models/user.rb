class User < ActiveRecord::Base
	belongs_to :team
	has_many :tokens
	validates :username, uniqueness: true, presence: true
	validates :username, :format => { :with => /[a-z0-9]+[-a-z0-9]*[a-z0-9]+/i }

	before_save :default_values

	def default_values
		self.admin = false
		self.generate_salt
	end

	def authenticate(password)
		if Digest::MD5.hexdigest(Digest::MD5.hexdigest(password) + self.salt) == self.password
			return true
		else
			return false
		end
	end

	def generate_salt
		if self.salt == nil
			random_string = SecureRandom.urlsafe_base64(8)
			self.update(:salt => random_string)
		end
	end

	def set_password(password)
		if self.salt == nil
			self.generate_salt
		end
		self.update(:password => Digest::MD5.hexdigest(Digest::MD5.hexdigest(password) + self.salt))
	end

	def api_filter
		return {
			:id => self.id,
			:username => self.username,
			:name => self.name,
			:admin => self.admin,
			:team => self.team
		}
	end
end
