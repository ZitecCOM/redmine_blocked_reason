'use strict';

var BlockWindow = (function (me, $) {
  var self = me || function (element) {
    this.modal = element;
    this.initialize();
  };

  var def = self.prototype;

  def.showModalNextTo = function (target) {
    var commentText = this.modal.find('.comment');
    if ($("#button_bar").length) {
      var parent = $("div.subject").after(this.modal)
    } else {
      var parent = target.closest('.block-reason')
      parent.find('.block-modal').hide();
      parent.append(this.modal);
    }
    this.modal.show();
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

  def.blockedCommentCompleted = function (modal) {
    var comment = modal.find('.comment');
    if (comment.val().length === 0 || !comment.val().trim()) {
      comment.attr('style', 'border-color:red;');
      return false;
    }
    comment.attr('style', 'border-color:#ccc;');
    return true;
  };

  def.blockedReasonLabelSelected = function (modal) {
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

  def.retrieveBlockedReasonData = function (modal) {
    return { blocked_reason: {
      comment: modal.find('.comment').val(),
      issue_id: modal.find('.issue-id').val(),
      blocked_reason_type: {
        id: modal.find('input[type=radio]:checked').val()
      }
    }};
  };

  def.createNewBlockedReason = function (modal) {
    $.ajax({
      dataType: 'json',
      method: 'POST',
      url: '/blocked_reasons/',
      data: this.retrieveBlockedReasonData(modal)
    }).done(function (response) {
      modal.remove();
      location.reload(true);
    }).fail(function (reason) {
      console.log('Could not create blocked reason!')
    });
  };

  def.updateBlockedReason = function (modal) {
    var id = modal.find('.block-reason-id').val();
    $.ajax({
      dataType: 'json',
      method: 'PUT',
      url: '/blocked_reasons/' + id,
      data: this.retrieveBlockedReasonData(modal)
    }).done(function (response) {
      modal.remove();
      location.reload(true);
    }).fail(function (reason) {
      console.log('Could not update blocked reason!')
    });
  };

  def.removeBlockedReason = function (modal) {
    var id = modal.find('.block-reason-id').val();
    $.ajax({
      dataType: 'json',
      method: 'DELETE',
      url: '/blocked_reasons/' + id,
      data: this.retrieveBlockedReasonData(modal)
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
      if (this.blockedCommentCompleted(modal) &&
          this.blockedReasonLabelSelected(modal)) {
        this.createNewBlockedReason(modal);
      }
    }.bind(this));
    modal.find('.update-block').on('click', function (event) {
      event.preventDefault();
      if (this.blockedCommentCompleted(modal) &&
          this.blockedReasonLabelSelected(modal)) {
        this.updateBlockedReason(modal);
      }
    }.bind(this));
    modal.find('.remove-block').on('click', function (event) {
      event.preventDefault();
      this.removeBlockedReason(modal);
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
    this.addModalClickEvents(this.modal);
    this.showCorrectFieldsIn(this.modal)
  };

  return self;
}(BlockWindow, $));

$(function () {
  var blockModal = $('.block-modal');
  if (blockModal.length) {
    var blockWindow = new BlockWindow(blockModal);
  }
  $('.block-tag').tooltip({
    position: {my: "center+3 top+15", at: "center bottom", collision: "flipfit"},
    tooltipClass: "arrow-top"
  });

  $('.block-tag .block-url').on('click', function (event) {
    event.preventDefault();
    event.stopPropagation();
    var element = $(event.target);
    var link = element.data('href');
    window.location = link;
  });
});
