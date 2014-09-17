class BlockedReasonType < ActiveRecord::Base
  unloadable
  has_one :blocked_reason
  attr_accessible :name
end
