module RedmineBlockedReason
  module Patches
    module BlockedTagHelperPatch
      def self.included(base)
        base.class_eval do
          def link_to_issue(issue, options={})
            title = nil
            subject = nil
            text = options[:tracker] == false ? "##{issue.id}" : "#{issue.tracker} ##{issue.id}"
            if options[:subject] == false
              title = issue.subject.truncate(60)
            else
              subject = issue.subject
              if truncate_length = options[:truncate]
                subject = subject.truncate(truncate_length)
              end
            end
            only_path = options[:only_path].nil? ? true : options[:only_path]
            s = link_to(text, issue_url(issue, :only_path => only_path),
                        :class => issue.css_classes, :title => title)
            s << h(": #{subject}") if subject
            s = h("#{issue.project} - ") + s if options[:project]
            blocked_reason = issue.blocked_reason
            s += render_blocked_reason_tag(blocked_reason) if blocked_reason
            s
          end

          def render_blocked_reason_tag(blocked_reason)
            type_id = blocked_reason.blocked_reason_type_id
            options = {
              controller: 'issues',
              action:     'index',
              set_filter: 1,
              fields:     [:status_id, :blocked_reason],
              operators:  { status_id: 'o', blocked_reason: '=' },
              values:     { status_id: ['o'], blocked_reason: [type_id]}
            }
            %[
              <span data-tip="#{blocked_reason.comment}" class="block-tag brt_tooltip #{blocked_reason.type_css_class}">
                #{link_to blocked_reason.type_name, options}
              </span>
            ].html_safe
          end
        end
      end
    end
  end
end

bases = [IssuesHelper, MyHelper, QueriesHelper]
patch = RedmineBlockedReason::Patches::BlockedTagHelperPatch
bases.each do |base|
  base.send(:include, patch) unless base.included_modules.include?(patch)
end
