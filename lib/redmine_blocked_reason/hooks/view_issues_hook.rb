module RedmineBlockedReason
  module Hooks
    class ViewsIssuesHook < Redmine::Hook::ViewListener
      render_on :view_issues_sidebar_planning_bottom, partial: 'issues/blocked_reason_sidebar'

      def view_layouts_base_html_head(context)
        project, controller = context[:project], context[:controller]
        controller.render_to_string(partial: 'blocked_reason/header_assets')
      end

      render_on :view_issues_show_details_bottom, partial: 'issues/blocked_reason_tag'

      def view_issues_form_details_bottom(context = {})
        context[:controller].send(:render_to_string, { :partial => 'issues/blocked_reason_window', :locals => context }) +
          context[:controller].send(:render_to_string, { :partial => 'issues/blocked_reason_button', :locals => context })
      end
    end
  end
end
