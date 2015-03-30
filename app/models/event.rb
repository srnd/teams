class Event < ActiveRecord::Base
  has_many :teams
  has_many :users

  def api_filter
    {
      :id => self.id,
      :city => self.city,
      :region_webname => self.region_webname,
      :batch => self.batch.api_filter
    }
  end
end
