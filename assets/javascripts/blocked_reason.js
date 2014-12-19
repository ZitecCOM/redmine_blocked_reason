$(document).on('click', function(event) {
  if (!$(event.target).closest('#blocked_reason_window').length && !$(event.target).closest('#block_issue_button').length) {
    $('#blocked_reason_window').hide();
    var block_issue_button = $('#block_issue_button');
    block_issue_button.unbind('click');
    initialize_blocked_reason();
  }
});

function initialize_blocked_reason(){
  var block_issue_button = $('#block_issue_button');
  var blocked_reason_window = $('#blocked_reason_window');
  var block_form_hide_button = $('#block_form_hide_button');
  var new_blocked_reason_button = $('#new_blocked_reason_button');
  var delete_blocked_reason_button = $('#delete_unblocked_button');
  var remove_blocked_reason_label = $('#removed_blocked_reason');
  var blocked_reason_comment = $('#blocked_reason_comment');
  var reason_label = $('#reason_label');
  var radio_buttons = $('.blocked_reason_form .radio-buttons')
  var blocked_title = $('.blocked-reason-window-title');
  var comment_label = $('#comment_label');

  $('#blocked_reason_window .field, #block_issue_button').click(function() {
    $('#blocked_reason_window #blocked_reason_comment').focus();
    switch_buttons();
  });

  blocked_reason_comment.val('');


  block_issue_button.bind('click', show_window);

  function show_window(event) {
    event.preventDefault();
    blocked_reason_window.show();
    var remove_label_input = $('#blocked_reason_blocked_reason_type_id_remove');
    if (remove_label_input[0]) {
      remove_label_input.prop("checked", true);
      comment_label.css('display','none');
    }
    switch_buttons();
    $('#blocked_reason_window #blocked_reason_comment').focus();
    block_issue_button.bind('click', hide_window);
  };

  function hide_window(event) {
    event.preventDefault();
    blocked_reason_window.hide();
    block_issue_button.unbind('click');
    block_issue_button.bind('click', show_window);
  };

  block_form_hide_button.bind('click', function() {
    blocked_reason_window.hide();
    block_issue_button.bind('click', show_window);
  });

  new_blocked_reason_button.bind('click', function(event) {
    event.preventDefault();
    if (blocked_comment_completed() && blocked_reason_label_selected()){
      $('.blocked_reason_form').submit();
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

  function blocked_reason_label_selected(){
    if ($('input[type=radio]:checked')[0]) {
      blocked_title.attr('style', 'color:#272727;');
      return true;
    }
    blocked_title.attr('style', 'color:#f75c5c;');
    return false;
  };

  function switch_buttons() {
    if ($('input[type=radio]:checked', '#blocked_reason_window').val() == 'remove'){
      new_blocked_reason_button.hide();
      remove_blocked_reason_label.show();
      comment_label.css('display','none');
    }
    else{
      new_blocked_reason_button.show();
      remove_blocked_reason_label.hide();
      comment_label.css('display','inline');
    }
  }

};

$(document).ready(function() {
  initialize_blocked_reason();

  $('.brt_tooltip').tipr({
    'speed': 0,
    'mode': 'bottom'
  });
});
