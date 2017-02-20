# docs
class RailsGem < ActiveRecord::Base
  validates :version, uniqueness: true
  validates :sha, uniqueness: true
end
