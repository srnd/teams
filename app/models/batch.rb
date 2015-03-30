class Batch < ActiveRecord::Base
  has_many :teams
  has_many :awards

  def api_filter
    {
      :id => self.id,
      :name => self.name,
      :current => self.current
    }
  end
end
