'use strict';

var BlockWindow = (function (me, $) {
  var self = me || function (root) {
    this.root = root;
    this.button = this.root.find('.block-button');
    this.modal = this.root.find('.block-modal');
    this.initialize();
  };

  var def = self.prototype;

  def.showModal = function () {
    var commentText = this.modal.find('.comment');
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

  def.blocked_comment_completed = function () {
    var comment = this.root.find('.comment');
    if (comment.val().length === 0 || !comment.val().trim()) {
      comment.attr('style', 'border-color:red;');
      return false;
    }
    comment.attr('style', 'border-color:#ccc;');
    return true;
  };

  def.blocked_reason_label_selected = function () {
    var title = this.root.find('h2');
    if (this.modal.find('input[type=radio]:checked')[0]) {
      title.attr('style', 'color:#272727;');
      return true;
    }
    title.attr('style', 'color:#f75c5c;');
    return false;
  };

  def.retrieve_blocked_reason_data = function () {
    return { blocked_reason: {
      comment: this.modal.find('.comment').val(),
      issue_id: this.modal.find('.issue-id').val(),
      blocked_reason_type: {
        id: this.modal.find('input[type=radio]:checked').val()
      }
    }};
  };

  def.create_new_blocked_reason = function () {
    $.ajax({
      dataType: 'json',
      method: 'POST',
      url: '/blocked_reasons/',
      data: this.retrieve_blocked_reason_data()
    }).done(function (response) {
      location.reload(true);
    }).fail(function (reason) {
      console.log('Something happeded')
    });
  };

  def.update_blocked_reason = function () {
    var id = this.modal.find('.block-reason-id').val();
    $.ajax({
      dataType: 'json',
      method: 'PUT',
      url: '/blocked_reasons/' + id,
      data: this.retrieve_blocked_reason_data()
    }).done(function (response) {
      location.reload(true);
    }).fail(function (reason) {
      console.log('Something happeded')
    });
  };

  def.remove_blocked_reason = function () {
    var id = this.modal.find('.block-reason-id').val();
    $.ajax({
      dataType: 'json',
      method: 'DELETE',
      url: '/blocked_reasons/' + id,
      data: this.retrieve_blocked_reason_data()
    }).done(function (response) {
      location.reload();
    }).fail(function (reason) {
      console.log('Something happeded');
    });
  };

  def.addModalClickEvents = function () {
    this.root.find('.block-hide').on('click', function (event) {
      event.preventDefault();
      this.modal.hide();
    }.bind(this));
    this.root.find('.new-block').on('click', function (event) {
      event.preventDefault();
      if (this.blocked_comment_completed() &&
          this.blocked_reason_label_selected()) {
        this.create_new_blocked_reason();
      }
    }.bind(this));
    this.root.find('.update-block').on('click', function (event) {
      event.preventDefault();
      if (this.blocked_comment_completed() &&
          this.blocked_reason_label_selected()) {
        this.update_blocked_reason();
      }
    }.bind(this));
    this.root.find('.remove-block').on('click', function (event) {
      event.preventDefault();
      this.remove_blocked_reason();
    }.bind(this));
  };

  def.initialize = function () {
    this.addButtonClickEvents();
    this.addModalClickEvents();
  };

  return self;
}(BlockWindow, $));

$(function () {
  $.map($('span.block-reason'), function (element) {
    return new BlockWindow($(element));
  });
  $('.brt_tooltip').tipr({ 'speed': 0, 'mode': 'bottom' });
});
