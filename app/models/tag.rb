class Tag < ActiveRecord::Base
  has_and_belongs_to_many :teams

  def as_hashtag
    self.text.gsub(" ", "")
  end
end
