module RedmineBlockedReason
  module Hooks
    class NewIssueViewHook < Redmine::Hook::ViewListener
      def new_issue_view_main_title_buttons(context)
        project, controller, issue = context[:project], context[:controller], context[:issue]
        return '' unless project.module_enabled? :blocked_reason
        blocked_reason = BlockedReason.where(issue_id: issue.id, active: true).first
        controller.render_to_string partial: 'blocked_reason/blocked_reason_button', locals: context
      end

      def view_layouts_base_html_head(context)
        project, controller = context[:project], context[:controller]
        # return '' if project.nil? || !project.module_enabled?(:blocked_reason)
        controller.render_to_string partial: 'blocked_reason/header_assets'
      end

      def view_issues_show_details_bottom(context)
        controller = context[:controller]
        blocked_reason = BlockedReason.where(issue_id: context[:issue].id, active: true).first
        return '' unless blocked_reason
        controller.render_to_string partial: 'blocked_reason/blocked_reason_show_details_tag', locals: context
      end

      def blocked_reason_tag_for(context)
        controller = context[:controller]
        blocked_reason = BlockedReason.where(issue_id: context[:issue].id, active: true).first
        return '' unless blocked_reason
        controller.render_to_string partial: 'blocked_reason/blocked_reason_tag', locals: context
      end
    end
  end
end
