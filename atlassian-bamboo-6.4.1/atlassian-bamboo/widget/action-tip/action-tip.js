define('widget/action-tip', [
    'jquery',
    'underscore',
    'backbone',
    'util/preferences'
], function(
    $,
    _,
    Backbone,
    preferencesManager
) {

    'use strict';

    var ActionTip = Backbone.View.extend({

        template: bamboo.widget.actionTip,

        preference: function(key) {
            return ['bamboo.user.actions', key].join('.');
        },

        defaults: {
            content: '',
            params: {
                onTop: false
            }
        },

        initialize: function(options) {
            this.settings = $.extend(this.defaults, options || {});

            if (!this.settings.label) {
                this.settings.label = $.trim(this.$el.text());
            }

            var params = $.extend({
                hideCallback: _.bind(this.onClose, this),
                container: 'body',
                noBind: true
            }, this.settings.params);

            this.dialog = AJS.InlineDialog(
                this.$el, this.$el.attr('id'),
                _.bind(this.onShow, this), params
            );

            this.registerEvents();
        },

        registerEvents: function() {
            this.$el.on('click', _.bind(this.onClick, this));

            $(document).on('keydown', _.bind(function(event) {
                if (event.keyCode === 27) this.hide();
            }, this.dialog));
        },

        onClick: function() {
            var value = false;

            if (this.settings.actionKey) {
                value = preferencesManager.getBoolean(
                    this.preference(this.settings.actionKey)
                );
            }

            if (!value) {
                this.dialog.show();
                return false;
            }

            this.dialog.remove();
        },

        onShow: function(dialog, trigger, show) {
            var content = this.template.dialog({
                label: this.settings.label,
                content: this.settings.content
            });

            dialog
                .html(content)
                .addClass('action-tip')
                .find('button').on('click', _.bind(function() {
                    this.onAction.call(this);
                    this.dialog.hide();
                }, this));

            show();
        },

        onClose: function() {
            if (this.clicked) {
                this.$el.click();
                this.dialog.remove();
            }
        },

        onAction: function() {
            if (this.settings.actionKey) {
                this.clicked = true;

                if (!this.settings.callback) {
                    preferencesManager.setValue(
                        this.preference(this.settings.actionKey)
                    );
                }
                else {
                    this.settings.callback.call(this);
                }
            }
        }

    });

    return ActionTip;
});