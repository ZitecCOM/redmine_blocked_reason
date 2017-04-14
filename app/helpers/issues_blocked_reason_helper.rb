module IssuesBlockedReasonHelper
  def blocked_reason_sidebar
    unless @blocked_reason_sidebar
      @blocked_reason_sidebar = []
      @blocked_reason_sidebar = BlockedReasonType.for_sidebar(project: @project).to_a
    end
    @blocked_reason_sidebar
  end

  def render_blocked_reason_tag(blocked_reason)
    type_id = blocked_reason.blocked_reason_type_id
    options = blocked_reason_issues_url_options(type_id)
    options[:project_id] = blocked_reason.issue.project.identifier
    %[
      <span title="#{j blocked_reason.comment}" class="block-tag label-#{j blocked_reason.type_css_class}">
        <span class="block-url" data-href="#{url_for options}">
          #{j blocked_reason.type_name}
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
      f:          [:status_id, :blocked_reason],
      operators:  { status_id: 'o', blocked_reason: '=' },
      op:         { status_id: 'o', blocked_reason: '=' },
      values:     { status_id: ['o'], blocked_reason: [type_id]},
      v:          { status_id: ['o'], blocked_reason: [type_id]}
    }
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
end
