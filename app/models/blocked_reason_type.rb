class BlockedReasonType < ActiveRecord::Base
  unloadable
  has_many :blocked_reason
  attr_accessible :name
end
