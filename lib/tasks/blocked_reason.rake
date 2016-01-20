desc 'Removed unused BlockedReason and BlockedReasonType'
task 'redmine:plugins:blocked_reason:remove_inactive' do
  BlockedReason.where(active: false).delete_all
  BlockedReason.where(unblocker: true).delete_all
  BlockedReasonType.where(removed: true).delete_all
end
