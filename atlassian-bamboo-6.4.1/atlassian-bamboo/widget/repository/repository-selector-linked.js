define('widget/repository-selector-linked', [
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

    var RepositorySelectorLinked = Brace.View.extend({

        mixins: [
            events.EventBusMixin
        ],

        initialize: function(options) {
            this.params = options.params || {};

            this.$selectedRepository = $('#selectedRepository');
            this.$select = this.$el.find('select:first');
            this.$select.auiSelect2({
                // by default select2 defines formatResult which does matching/highlighting
                formatResult: function(item) {
                    return item.text;
                }
            });

            this.$select.on('change', _.bind(function(event) {
                if (event.val.length > 0 && event.added) {
                    this.onSelectRepository(event.added.id);
                }
            }, this));

            this.onEvent('repository:selector:form',
                this.onFormChanged
            );
        },

        onFormChanged: function(instance, type) {
            if (type === 'LINKED') {
                this.onSelectRepository(this.getSelectedKey());
            }
        },

        onSelectRepository: function(key) {
            var $container = $(['#repository-shared', key].join('-'));

            if ($container.length && !$container.is(':visible')) {
                var repositories = this.$el.find('.repository:visible');

                if (!repositories.length) {
                    $container.delay(400).slideDown();
                }
                else {
                    repositories.slideUp();
                    $container.slideDown();
                }
            }

            this.$selectedRepository.val(key);
            this.$selectedRepository.trigger('change');
        },

        getSelectedKey: function() {
            return this.$select.val();
        }

    });
    return RepositorySelectorLinked;
});
