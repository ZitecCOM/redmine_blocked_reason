module RedmineBlockedReason
  module Hooks
    class NewIssueViewHook < Redmine::Hook::ViewListener
      def blocked_reason_button(context)
        project, controller, issue = context[:project], context[:controller], context[:issue]
        return '' unless project.module_enabled? :blocked_reason
        blocked_reason = BlockedReason.where(issue_id: issue.id, active: true).first
        controller.render_to_string partial: 'blocked_reason/blocked_reason_button', locals: context
      end

      def view_layouts_base_html_head(context)
        project, controller = context[:project], context[:controller]
        controller.render_to_string partial: 'blocked_reason/header_assets'
      end

      def view_issues_show_details_bottom(context)
        controller, issue = context[:controller], context[:issue]
        blocked_reason = BlockedReason.where(issue_id: issue.id, active: true).first || BlockedReason.new
        context[:block_reason] = blocked_reason
        result = controller.render_to_string partial: 'blocked_reason/blocked_reason_window', locals: context
        return result unless blocked_reason.id
        result << controller.render_to_string(partial: 'blocked_reason/blocked_reason_show_details_tag', locals: context)
      end

      def issue_list_subject_column(context)
        controller, issue = context[:controller], context[:issue]
        blocked_reason = issue.blocked_reasons.where(active: true).first
        if blocked_reason
          context[:blocked_reason] = blocked_reason
          controller.render_to_string partial: 'blocked_reason/blocked_reason_tag', locals: context
        else
          ''
        end
      end
    end
  end
end
