module RedmineBlockedReason
  module Hooks
    class NewIssueViewHook < Redmine::Hook::ViewListener
      def new_issue_view_blocked_reason_button(context)
        project, controller = context[:project], context[:controller]
        if project.module_enabled? :blocked_reason
          controller.render_to_string partial: 'blocked_reason/show', locals: context
        else
          ''
        end
      end

      def view_layouts_base_html_head(context)
        project, controller = context[:project], context[:controller]
        if !project.nil? && project.module_enabled?(:blocked_reason)
          controller.render_to_string partial: 'blocked_reason/header_assets'
        else
          ''
        end
      end

      def new_issue_view_rows_subject(context)
        unless context[:issue].blocked_reason.nil?
          "<span data-tip='#{h(context[:issue].blocked_reason.comment)}' class='tip blocked_reason_comment'>#{I18n.t 'blocked_reason'}: #{h(context[:issue].blocked_reason.type_name)}</span>".html_safe
        end
      end
    end
  end
end