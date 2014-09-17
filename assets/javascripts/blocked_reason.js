$(document).ready(function() {
    $('#block_issue_button').bind('click', function() {
      $('#blocked_reason_form').show();
    });
    $('#new_blocked_reason').bind('submit', function() {
      var items = ['blocked_reason_blocked_reason_type_id', 'blocked_reason_comment']
      for(var i in items) {
        var element = $('#' + items[i]);
        if (element.val() == ''){ 
          element.attr('style', 'border-color:red;')
          return false;
        }
      }
      return true;
    });
    $('.tip').tipr({
          // 'speed': 300,
          // 'mode': 'top'
     });
});