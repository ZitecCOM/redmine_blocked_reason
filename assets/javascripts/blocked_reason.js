'use strict';

var BlockWindow = (function ($) {
  var self = function (root) {
    this.root = root;
    this.button = this.root.find('.block-button');
    this.modal = this.root.find('.block-modal');
    this.initialize();
  };

  var def = self.prototype;

  def.showModal = function () {
    var commentText = this.modal.find('.comment-text');
    this.modal.show();
    commentText.focus();
  };

  def.addButtonClickEvents = function () {
    this.button.on('click', function (event) {
      event.preventDefault();
      this.showModal();
    }.bind(this));

    $(document).on('click', function (event) {
      var target = $(event.target);
      var closestRoot = target.closest('span.block-reason');
      if (!closestRoot.length || closestRoot[0] !== this.root[0]) {
        this.modal.hide();
      }
    }.bind(this));
  };

  // def.addModalClickEvents = function () {

  // };

  def.initialize = function () {
    this.addButtonClickEvents();
    // this.addModalClickEvents();
  };

  return self;
}($));

$(function () {
  $.map($('span.block-reason'), function (element) {
    return new BlockWindow($(element));
  });
  $('.brt_tooltip').tipr({ 'speed': 0, 'mode': 'bottom' });
});

//   blockButton.on('click', show_window);

//   function show_window(event) {
//     event.preventDefault();
//     blocked_reason_window.show();
//     var remove_label_input = $('#blocked_reason_blocked_reason_type_id_remove');
//     if (remove_label_input[0]) {
//       remove_label_input.prop("checked", true);
//       comment_label.css('display','none');
//     }
//     switch_buttons();
//     $('.block-modal .blocked_reason_comment').focus();
//     blockButton.bind('click', hide_window);
//   };

//   function hide_window(event) {
//     event.preventDefault();
//     blocked_reason_window.hide();
//     blockButton.unbind('click');
//     blockButton.bind('click', show_window);
//   };

//   block_form_hide_button.bind('click', function () {
//     blocked_reason_window.hide();
//     blockButton.bind('click', show_window);
//   });

//   new_blocked_reason_button.bind('click', function (event) {
//     event.preventDefault();
//     if (blocked_comment_completed() && blocked_reason_label_selected()){
//       $('.blocked_reason_form').submit();
//     }
//   });

//   delete_blocked_reason_button.bind('click', function (event) {
//     event.preventDefault();
//     $('#deleted_comment').val(blocked_reason_comment.val());
//     $('#delete_button_form').submit();
//   });

//   function blocked_comment_completed() {
//     if (blocked_reason_comment.val().length === 0 || !blocked_reason_comment.val().trim()) {
//       blocked_reason_comment.attr('style', 'border-color:red;');
//       return false;
//     }
//     blocked_reason_comment.attr('style', 'border-color:#ccc;');
//     return true;
//   };

//   function blocked_reason_label_selected() {
//     if ($('input[type=radio]:checked')[0]) {
//       blocked_title.attr('style', 'color:#272727;');
//       return true;
//     }
//     blocked_title.attr('style', 'color:#f75c5c;');
//     return false;
//   };

//   function switch_buttons() {
//     if ($('input[type=radio]:checked', '.block-modal').val() == 'remove'){
//       new_blocked_reason_button.hide();
//       remove_blocked_reason_label.show();
//       comment_label.css('display','none');
//     }
//     else{
//       new_blocked_reason_button.show();
//       remove_blocked_reason_label.hide();
//       comment_label.css('display','inline');
//     }
//   }
// };
