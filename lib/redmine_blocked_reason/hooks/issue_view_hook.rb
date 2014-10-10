module RedmineBlockedReason
  module Hooks
    class IssueViewHook < Redmine::Hook::ViewListener
      def view_issues_buttons(context)
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

      def view_issues_rows_subject(context)
        unless context[:issue].blocked_reason.nil?
          "<span data-tip='#{h(context[:issue].blocked_reason.comment)}' class='tip blocked_reason_comment'>#{h(context[:issue].blocked_reason.type_name)}</span>".html_safe
        end
      end
    end
  end
end