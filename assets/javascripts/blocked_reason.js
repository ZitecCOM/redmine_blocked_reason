$(document).ready(function() {
  block_issue_button = $('#block_issue_button');
  blocked_reason_form = $('#blocked_reason_form');
  block_form_hide_button = $('#block_form_hide_button');
  new_blocked_reason = $('#new_blocked_reason');

  block_issue_button.bind('click', function() {
    blocked_reason_form.show();
    blocked_reason_form.attr('top',block_issue_button.position().top);
    blocked_reason_form.attr('left',block_issue_button.position().left + block_issue_button.width());
  });
  block_form_hide_button.bind('click', function() {
    blocked_reason_form.hide();
  });
  new_blocked_reason.bind('submit', function() {
    return true;
  });

  $('.brt_tooltip').tipr({
    'speed': 0,
    'mode': 'bottom'
  });
});