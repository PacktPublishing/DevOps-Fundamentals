define('widget/autocomplete', [
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

    var Autocomplete = Brace.View.extend({

        mixins: [
            events.EventBusMixin
        ],

        initialize: function(options) {
            this.data = [];

            options.initialValue = $.parseJSON(
                options.initialValue || null
            );

            if (_.isFunction(this.onInitSelection)) {
                options.initSelection = _.bind(this.onInitSelection, this);
            }

            this.settings = $.extend({
                escapeMarkup: function(m) {
                    return m;
                },
                placeholder: ' '
            }, options || {});

            if (!this.$el.val()) {
                if (!options.initialValue && options.loadAndProcess && this.onLoadAndProcess) {
                    this.settings.initSelection = _.bind(this.onLoadAndProcess, this);
                    this.$el.val('__LOADING__');
                }
            }

            this.$el.auiSelect2(this.settings);
            this.$el.on('change', _.bind(function() {
                $('#select2-drop-mask').hide();

                this.$el.auiSelect2('dropdown').hide();
                this.$el.auiSelect2('container')
                    .removeClass('select2-dropdown-open')
                    .removeClass('select2-container-active');
            }, this));

            this.onRegisterEvents();
        },

        onRegisterEvents: function() {
            this.proxyEvents('select',
                ['change', 'select2-open', 'select2-blur'],
                this.$el
            );
        },

        getSelectedData: function(callback) {
            var selected = this.$el.auiSelect2('data');

            if (!selected) {
                selected = _.find(this.data.results, _.bind(callback || function(item) {
                    return item.id === this.$el.val();
                }, this));
            }

            return selected;
        },

        initConfig: function(values) {
            var defaults = _.defaults(values || {}, {
                placeholder: this.settings.placeholder,
                data: []
            });

            this.$el.auiSelect2(_.defaults(
                defaults,
                this.settings
            ));

            return this;
        },

        getContainer: function() {
            return this.$el.auiSelect2('container');
        },

        addLoadingIcon: function() {
            var $icon = $(document.createElement('span'))
                .addClass('aui-icon aui-icon-wait');

            this.$el.siblings('.select2-container:first').append($icon);
            return this;
        },

        removeLoadingIcon: function() {
            setTimeout(_.bind(function() {
                this.$el.parent().find('.aui-icon-wait').fadeOut();
            }, this), 500);

            return this;
        },

        clearValue: function() {
            this.$el.auiSelect2('data', null);
            return this;
        },

        processData: function(data) {
            this.data = data;
            return this.data;
        },

        disable: function() {
            this.$el.auiSelect2('enable', false);
            return this;
        },

        enable: function() {
            this.$el.auiSelect2('enable', true);
            return this;
        }

    });

    return Autocomplete;

});

/**
 * Export functionality onto Bamboo prototype.
 * To be removed in 6.0
 * @deprecated
 */
if (AJS.namespace) {
    AJS.namespace('Bamboo.Widget.Autocomplete', null, require('widget/autocomplete'));
}