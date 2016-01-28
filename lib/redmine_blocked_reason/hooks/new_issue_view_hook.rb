module RedmineBlockedReason
  module Hooks
    class NewIssueViewHook < Redmine::Hook::ViewListener
      def blocked_reason_button(context)
        project = context[:project]
        controller = context[:controller]
        issue = context[:issue]

        return '' unless project.module_enabled?(:blocked_reason)
        return '' if Redmine::Plugin.installed?(:luxury_buttons) &&
          project.module_enabled?(:luxury_buttons)

        controller.render_to_string(
          partial: 'blocked_reason/blocked_reason_button',
          locals:  context
        )
      end

      def view_layouts_base_html_head(context)
        project, controller = context[:project], context[:controller]
        controller.render_to_string(partial: 'blocked_reason/header_assets')
      end

      def view_issues_show_details_bottom(context)
        controller, issue = context[:controller], context[:issue]
        blocked_reason = issue.blocked_reason || BlockedReason.new
        result = controller.render_to_string(
          partial: 'blocked_reason/blocked_reason_window',
          locals:  {
            issue: issue,
            blocked_reason: blocked_reason
          }
        )
        return result unless blocked_reason.id
        result + controller.render_to_string(
          partial: 'blocked_reason/blocked_reason_show_details_tag',
          locals:  { blocked_reason: blocked_reason }
        )
      end

      def view_issues_sidebar_planning_bottom(context)
        controller = context[:controller]
        project = context[:project]

        reasons = BlockedReasonType.for_sidebar(project: project).to_a

        if reasons.any?
          controller.render_to_string(
            partial: 'blocked_reason/issues_sidebar',
            locals: {reasons: reasons}
          )
        else
          ''
        end
      end
    end
  end
end
