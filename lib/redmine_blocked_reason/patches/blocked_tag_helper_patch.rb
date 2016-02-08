module RedmineBlockedReason
  module Patches
    module BlockedTagHelperPatch
      def self.included(base)
        base.class_eval do

          def render_blocked_reason_tag(blocked_reason)
            type_id = blocked_reason.blocked_reason_type_id
            options = blocked_reason_issues_url_options(type_id)
            %[
              <span title="#{j blocked_reason.comment}" class="block-tag label-#{j blocked_reason.type_css_class}">
                <span class="block-url" data-href="#{url_for options}">
                  #{j blocked_reason.type_name}
                </span>
              </span>
            ].html_safe
          end

          def render_sidebar_blocked_reason_type(blocked_type)
            options = blocked_reason_issues_url_options(blocked_type.id)
            %[
              <span class="block-tag label-#{j blocked_type.css_class}">
                <span class="block-url" data-href="#{url_for options}">
                  #{j blocked_type.name}: #{blocked_type.count}
                </span>
              </span>
            ].html_safe
          end

          def blocked_reason_issues_url_options(type_id)
            {
              controller: 'issues',
              action:     'index',
              set_filter: 1,
              fields:     [:status_id, :blocked_reason],
              operators:  { status_id: 'o', blocked_reason: '=' },
              values:     { status_id: ['o'], blocked_reason: [type_id]}
            }
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
