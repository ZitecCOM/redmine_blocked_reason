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
  var delete_blocked_reason_button = $('#delete_unblocked_button');
  var remove_blocked_reason_label = $('#removed_blocked_reason');
  var blocked_reason_comment = $('#blocked_reason_comment');
  var reason_label = $('#reason_label');


  $('#blocked_reason_window .field, #block_issue_button').click(function() {
    $('#blocked_reason_window #blocked_reason_comment').focus();
    switch_buttons();
  });

  blocked_reason_comment.val('');

  block_issue_button.bind('click', function(event) {
    event.preventDefault();
    var position = block_issue_button.position();
    blocked_reason_window.show();
    $('#blocked_reason_window .field:first > input[type="radio"]').prop("checked", true);
    switch_buttons();
    $('#blocked_reason_window #blocked_reason_comment').focus();
  });

  block_form_hide_button.bind('click', function() {
    blocked_reason_window.hide();
  });

  new_blocked_reason_button.bind('click', function(event) {
    event.preventDefault();
    if (blocked_comment_completed()){
      $('#new_blocked_reason').submit();
    }
  });

  delete_blocked_reason_button.bind('click', function(event) {
    event.preventDefault();
    $('#deleted_comment').val(blocked_reason_comment.val());
    $('#delete_button_form').submit();
  });

  function blocked_comment_completed() {
    if (blocked_reason_comment.val().length === 0 || !blocked_reason_comment.val().trim()) {
      blocked_reason_comment.attr('style', 'border-color:red;');
      return false;
    }
    blocked_reason_comment.attr('style', 'border-color:#ccc;');
    return true;
  };

  function switch_buttons() {
    if ($('input[type=radio]:checked', '#blocked_reason_window').val() == 'remove'){
      new_blocked_reason_button.hide();
      remove_blocked_reason_label.show();
    }
    else{
      new_blocked_reason_button.show();
      remove_blocked_reason_label.hide();
    }
  }

  $('.brt_tooltip').tipr({
    'speed': 0,
    'mode': 'bottom'
  });
});
