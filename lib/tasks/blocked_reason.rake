desc 'Removed unused BlockedReason and BlockedReasonType'
task 'redmine:plugins:blocked_reason:remove_inactive' => :environment do
  BlockedReason.where(active: false).delete_all
  BlockedReason.where(unblocker: true).delete_all
  BlockedReasonType.where(removed: true).delete_all
end

desc 'Change label css classes to new format'
task 'redmine:plugins:blocked_reason:update_label_css_classes' => :environment do
  BlockedReasonType.where(css_class: 'label_type_1').update_all(css_class: 'success')
  BlockedReasonType.where(css_class: 'label_type_2').update_all(css_class: 'info')
  BlockedReasonType.where(css_class: 'label_type_3').update_all(css_class: 'danger')
end
