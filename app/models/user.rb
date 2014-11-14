class User < ActiveRecord::Base
	belongs_to :team
	validates :username, uniqueness: true

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
end
