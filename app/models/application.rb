class Application < ActiveRecord::Base
  belongs_to :user

  def api_filter
    {
      :id => self.id,
      :name => self.name,
      :description => self.description,
      :user => self.user.api_filter
    }
  end
end
