module RedmineBlockedReason
  module Hooks
    class NewIssueViewHook < Redmine::Hook::ViewListener
      def new_issue_view_blocked_reason_button(context)
        project, controller, issue = context[:project], context[:controller], context[:issue]
        return '' unless project.module_enabled? :blocked_reason
        blocked_reason = BlockedReason.where(issue_id: issue.id, active: true).first
        if blocked_reason
          controller.render_to_string partial: 'blocked_reason/blocked_reason_label', locals: {issue: issue, blocked_reason: blocked_reason}
        else
          controller.render_to_string partial: 'blocked_reason/blocked_reason_button', locals: context
        end
      end

      def view_layouts_base_html_head(context)
        project, controller = context[:project], context[:controller]
        # return '' if project.nil? || !project.module_enabled?(:blocked_reason)
        controller.render_to_string partial: 'blocked_reason/header_assets'
      end
    end
  end
end