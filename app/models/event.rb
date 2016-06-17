class Event < ActiveRecord::Base
  has_many :teams
  has_many :users

  def api_filter
    {
      :id => self.id,
      :city => self.city,
      :batch => self.batch.api_filter
    }
  end
end
