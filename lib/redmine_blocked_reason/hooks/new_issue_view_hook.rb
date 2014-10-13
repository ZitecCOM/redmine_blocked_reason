module RedmineBlockedReason
  module Hooks
    class NewIssueViewHook < Redmine::Hook::ViewListener
      def new_issue_view_blocked_reason_button(context)
        project, controller, issue = context[:project], context[:controller], context[:issue]
        return '' unless project.module_enabled? :blocked_reason
        if issue.blocked_reason.nil?
          controller.render_to_string partial: 'blocked_reason/blocked_reason_button', locals: context
        else
          controller.render_to_string partial: 'blocked_reason/blocked_reason_label', locals: context
        end
      end

      def view_layouts_base_html_head(context)
        project, controller = context[:project], context[:controller]
        return '' if project.nil? || !project.module_enabled?(:blocked_reason)
        controller.render_to_string partial: 'blocked_reason/header_assets'
      end

      def new_issue_view_rows_subject(context)
        return '' if context[:issue].blocked_reason.nil?
        "<span data-tip='#{h(context[:issue].blocked_reason.comment)}' class='tip blocked_reason_tag'>#{I18n.t 'blocked_reason'}: #{h(context[:issue].blocked_reason.type_name)}</span>".html_safe
      end
    end
  end
end