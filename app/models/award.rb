class Award < ActiveRecord::Base
  belongs_to :team
  belongs_to :batch
end
