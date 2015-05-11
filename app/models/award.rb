class Award < ActiveRecord::Base
  belongs_to :team
  belongs_to :batch

  def api_filter
    {
      :id => self.id,
      :name => self.name,
      :description => self.description,
      :team => self.team.api_filter,
      :event => self.event.api_filter,
    }
  end
end