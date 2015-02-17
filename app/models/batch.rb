class Batch < ActiveRecord::Base
  has_many :teams
  has_many :awards
end
