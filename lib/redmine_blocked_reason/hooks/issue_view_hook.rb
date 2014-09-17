module RedmineBlockedReason
  module Hooks
    class IssueViewHook < Redmine::Hook::ViewListener
      render_on :view_issues_buttons, :partial => "blocked_reason/show"
      def view_issues_rows(context)
        unless context[:issue].blocked_reason.nil?
          context[:rows].left l(:blocked_reason), "<span data-tip='#{h(context[:issue].blocked_reason.comment)}' class='tip blocked_reason_comment'>#{h(context[:issue].blocked_reason.type_name)}</span>".html_safe, :class => 'blocked_reason'
        end
      end
    end
  end
end