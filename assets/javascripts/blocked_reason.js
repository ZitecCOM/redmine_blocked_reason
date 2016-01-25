'use strict';

var BlockWindow = (function (me, $) {
  var self = me || function (selector) {
    this.template = $(selector);
    this.initialize();
  };

  var def = self.prototype;

  def.showModalNextTo = function (target) {
    var modal = this.template.clone();
    var commentText = modal.find('.comment');
    if ($("#button_bar").length) {
      var parent = $("div.subject").after(modal)
    } else {
      var parent = target.closest('.block-reason')
      parent.find('.block-modal').remove();
      parent.append(modal);
    }
    this.addModalClickEvents(modal);
    this.showCorrectFieldsIn(modal)
    modal.show();
    commentText.focus();
  };

  def.addButtonClickEvents = function () {
    $('.lb_btn_lock').addClass('fake_btn').on('click', function (event) {
      event.preventDefault();
      this.showModalNextTo($(event.target));
    }.bind(this));

    $(document).on('click', function (event) {
      var target = $(event.target);
      var closestButton = target.closest('.block-reason');
      if (!closestButton.length) {
        $('.block-reason .block-modal').remove();
      }
    }.bind(this));
  };

  def.blocked_comment_completed = function (modal) {
    var comment = modal.find('.comment');
    if (comment.val().length === 0 || !comment.val().trim()) {
      comment.attr('style', 'border-color:red;');
      return false;
    }
    comment.attr('style', 'border-color:#ccc;');
    return true;
  };

  def.blocked_reason_label_selected = function (modal) {
    var title = modal.find('h2').filter(function () {
      return this.style.display !== 'none';
    });
    if (modal.find('input[type=radio]:checked')[0]) {
      title.attr('style', 'color:#272727;');
      return true;
    }
    title.attr('style', 'color:#f75c5c;');
    return false;
  };

  def.retrieve_blocked_reason_data = function (modal) {
    return { blocked_reason: {
      comment: modal.find('.comment').val(),
      issue_id: modal.find('.issue-id').val(),
      blocked_reason_type: {
        id: modal.find('input[type=radio]:checked').val()
      }
    }};
  };

  def.create_new_blocked_reason = function (modal) {
    $.ajax({
      dataType: 'json',
      method: 'POST',
      url: '/blocked_reasons/',
      data: this.retrieve_blocked_reason_data(modal)
    }).done(function (response) {
      modal.remove();
      location.reload(true);
    }).fail(function (reason) {
      console.log('Could not create blocked reason!')
    });
  };

  def.update_blocked_reason = function (modal) {
    var id = modal.find('.block-reason-id').val();
    $.ajax({
      dataType: 'json',
      method: 'PUT',
      url: '/blocked_reasons/' + id,
      data: this.retrieve_blocked_reason_data(modal)
    }).done(function (response) {
      modal.remove();
      location.reload(true);
    }).fail(function (reason) {
      console.log('Could not update blocked reason!')
    });
  };

  def.remove_blocked_reason = function (modal) {
    var id = modal.find('.block-reason-id').val();
    $.ajax({
      dataType: 'json',
      method: 'DELETE',
      url: '/blocked_reasons/' + id,
      data: this.retrieve_blocked_reason_data(modal)
    }).done(function (response) {
      modal.remove();
      location.reload(true);
    }).fail(function (reason) {
      console.log('Could not remove blocked reason!')
    });
  };

  def.addModalClickEvents = function (modal) {
    modal.find('.block-hide').on('click', function (event) {
      event.preventDefault();
      modal.hide();
    }.bind(this));
    modal.find('.new-block').on('click', function (event) {
      event.preventDefault();
      if (this.blocked_comment_completed(modal) &&
          this.blocked_reason_label_selected(modal)) {
        this.create_new_blocked_reason(modal);
      }
    }.bind(this));
    modal.find('.update-block').on('click', function (event) {
      event.preventDefault();
      if (this.blocked_comment_completed(modal) &&
          this.blocked_reason_label_selected(modal)) {
        this.update_blocked_reason(modal);
      }
    }.bind(this));
    modal.find('.remove-block').on('click', function (event) {
      event.preventDefault();
      this.remove_blocked_reason(modal);
    }.bind(this));
    modal.find('.radio-buttons input').on('change', function (event) {
      if (event.target.value === 'remove') {
        modal.find('.update-block').hide();
        modal.find('.remove-block').show();
      } else {
        var new_reason = modal.find('.block-reason-id').val().length == 0
        modal.find('.remove-block').hide();
        if (!new_reason) {
          modal.find('.update-block').show();
        }
      }
    }.bind(this));
  };

  def.showCorrectFieldsIn = function (modal) {
    var type_id = modal.find('.block-reason-type-id').val();
    var new_reason = modal.find('.block-reason-id').val().length == 0
    if (new_reason) {
      modal.find('.title-new').show();
      modal.find('.title-update').hide();
      modal.find('.label-remove').hide();
      modal.find('.new-block').show();
      modal.find('.update-block').hide();
      modal.find('.remove-block').hide();
      modal.find('input[type=radio]:checked').prop('checked', false);
    } else {
      modal.find('.title-new').hide();
      modal.find('.title-update').show();
      modal.find('.label-remove').show();
      modal.find('.new-block').hide();
      modal.find('.update-block').show();
      modal.find('.remove-block').hide();
      modal.find('input[type=radio]:checked').prop('checked', false);
      modal.find('.radio-buttons input[value="'+ type_id + '"]').prop('checked', true);
    }
  };

  def.initialize = function () {
    this.addButtonClickEvents();
  };

  return self;
}(BlockWindow, $));

$(function () {
  var blockWindow = new BlockWindow('.block-modal');
  $('.brt_tooltip').tipr({ 'speed': 0, 'mode': 'bottom' });

  $('.block-tag').on('click', function (event) {
    event.preventDefault();
    event.stopPropagation();
    var element = $(event.target);
    var link = element.data('href');
    window.location = link;
  });
});
