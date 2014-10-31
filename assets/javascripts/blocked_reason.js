$(document).on('click', function(event) {
  if (!$(event.target).closest('#blocked_reason_window').length && !$(event.target).closest('#block_issue_button').length) {
    $('#blocked_reason_window').hide();
  }
});

$(document).ready(function() {
  var block_issue_button = $('#block_issue_button');
  var blocked_reason_window = $('#blocked_reason_window');
  var block_form_hide_button = $('#block_form_hide_button');
  var new_blocked_reason_button = $('#new_blocked_reason_button');
  var blocked_reason_comment = $('#blocked_reason_comment');
  var reason_label = $('#reason_label');

  blocked_reason_comment.val('');
  block_issue_button.bind('click', function(event) {
    event.preventDefault();
    var position = block_issue_button.position();
    var pos_top = position.top;
    var pos_left = position.left;
    blocked_reason_window.css({
      top: pos_top,
      left: pos_left
    });
    blocked_reason_window.show();
  });
  block_form_hide_button.bind('click', function() {
    blocked_reason_window.hide();
  });
  new_blocked_reason_button.bind('click', function(event) {
    event.preventDefault();
    if (blocked_reason_comment.val().length === 0 || !blocked_reason_comment.val().trim()) {
      blocked_reason_comment.attr('style', 'border-color:red;');
      return false;
    }
    else {
      blocked_reason_comment.attr('style', 'border-color:#ccc;');
    }
    if (!$('input[type=radio]:checked', '#blocked_reason_window').val()) {
      reason_label.attr('style', 'color:red;');
      return false;
    }
    else {
      reason_label.attr('style', 'color:black;');
    }
    $('.blocked_reason_form').submit();
  });

  $('.brt_tooltip').tipr({
    'speed': 0,
    'mode': 'bottom'
  });
});
