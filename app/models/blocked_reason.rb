class BlockedReason < ActiveRecord::Base
  unloadable
  belongs_to :blocked_reason_type
  belongs_to :issue
  delegate :name, to: :blocked_reason_type, prefix: :type

end
