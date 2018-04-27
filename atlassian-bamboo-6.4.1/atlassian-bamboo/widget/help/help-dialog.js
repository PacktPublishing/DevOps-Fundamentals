define('widget/help-dialog', [
    'jquery',
    'underscore',
    'brace',
    'util/events'
], function(
    $,
    _,
    Brace,
    events
) {

    'use strict';

    var HelpDialog = Brace.View.extend({

        mixins: [events.EventBusMixin],

        initialize: function() {
            AJS.InlineDialog(
                this.$el,
                this.$el.attr('id').replace(/[:\.]/g, "-"),
                _.bind(this.onDialogShow, this),
                {
                    hideDelay: null,
                    offsetX: -60,
                    arrowOffsetX: 0,
                    width: 420
                }
            );
        },

        onDialogShow: function(content, trigger, showPopup) {
            content.css({ padding: '20px' })
                .html((this.options.content || this.$el.find('span:first')).html());

            showPopup();
            return false;
        }
    });

    return HelpDialog;

});


/**
 * Export functionality onto Bamboo prototype.
 * To be removed in 6.0
 * @deprecated
 */
if (AJS.namespace) {
    AJS.namespace('Bamboo.Widget.HelpDialog', null, require('widget/help-dialog'));
}