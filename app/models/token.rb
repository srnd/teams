class Token < ActiveRecord::Base
  belongs_to :application
  belongs_to :user

  def self.generate(application, user)
    token = Token.create(:access_token => SecureRandom::hex(20), :token_string => SecureRandom::hex(20), :application_id => application.id, :user_id => user.id)
    return token
  end

  def self.token_for(application, user)
    if Token.where(:application_id => application.id, :user_id => user.id).first.is_a? Token
      return Token.where(:application_id => application.id, :user_id => user.id).first
    else
      return Token.generate(application, user)
    end
  end

  def self.user_with_token(application, token)
    if Token.where(:application_id => application.id, :token_string => token).first.is_a? Token
      return Token.where(:application_id => application.id, :token_string => token).first.user
    else
      return false
    end
  end

  def self.exchange(application, token)
    if Token.where(:application_id => application.id, :access_token => token).first.is_a? Token
      return Token.where(:application_id => application.id, :access_token => token).first.token_string
    else
      return ""
    end
  end
end
