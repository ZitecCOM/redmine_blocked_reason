class BlockedReasonType < ActiveRecord::Base
  unloadable
  has_many :blocked_reason
  attr_accessible :name, :css_class
end
