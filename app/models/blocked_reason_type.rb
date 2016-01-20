class BlockedReasonType < ActiveRecord::Base
  has_many :blocked_reason
  attr_accessible :name, :css_class
end
