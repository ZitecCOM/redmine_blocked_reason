$(document).on('click', function(event) {
  if (!$(event.target).closest('#blocked_reason_form').length && !$(event.target).closest('#block_issue_button').length) {
    $('#blocked_reason_form').hide();
  }
});

$(document).ready(function() {
  var block_issue_button = $('#block_issue_button');
  var blocked_reason_form = $('#blocked_reason_form');
  var block_form_hide_button = $('#block_form_hide_button');
  var new_blocked_reason_button = $('#new_blocked_reason');
  var blocked_reason_comment = $('#blocked_reason_comment');
  var reason_label = $('#reason_label');

  blocked_reason_comment.val('');
  block_issue_button.bind('click', function() {
    var position = block_issue_button.position();
    var pos_top = position.top + block_issue_button.height();
    var pos_left = position.left - blocked_reason_form.width() + block_issue_button.width() / 2;
    blocked_reason_form.css({
      top: pos_top,
      left: pos_left
    });
    blocked_reason_form.show();
  });
  block_form_hide_button.bind('click', function() {
    blocked_reason_form.hide();
  });
  new_blocked_reason_button.bind('click', function() {
    if (blocked_reason_comment.val().length === 0 || !blocked_reason_comment.val().trim()){
      blocked_reason_comment.attr('style', 'border-color:red;')
      return false;
    }
    if (!$('input[type=radio]:checked', '#blocked_reason_form').val()){
      reason_label.attr('style', 'color:red;')
      return false;
    }
    return true;
  });

  $('.brt_tooltip').tipr({
    'speed': 0,
    'mode': 'bottom'
  });
});