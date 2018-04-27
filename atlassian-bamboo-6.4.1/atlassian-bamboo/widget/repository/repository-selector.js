define('widget/repository-selector', [
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

    var RepositorySelector = Brace.View.extend({

        mixins: [
            events.EventBusMixin
        ],

        initialize: function() {
            this.$selectedRepository = $('#selectedRepository');
            this.$selectedRepository.on('change', _.bind(function() {
                this.triggerEvent('repository:selector:change',
                    this.$el.find('input:radio[name="repositoryTypeOption"]:checked').val(),
                    this.$selectedRepository.val()
                );

                if (this.$selectedRepository.val().length) {
                    this.$el.find('.radio > .error').remove();
                }
            }, this));

            var callback = _.bind(function(input) {
                if (input.length) {
                    if (input.val() === 'NONE') {
                        this.$selectedRepository.val('nullRepository');
                        this.$selectedRepository.trigger('change');
                    } else {
                        this.triggerEvent('repository:selector:form', input.val());
                    }
                }
            }, this);

            $(document).on('change',
                'form input:radio[name="repositoryTypeOption"]', function(event) {
                    callback($(event.target));
                }
            );

            var $typeOption = this.$el.find(
                'input:radio[name="repositoryTypeOption"]:checked'
            );

            if ($typeOption.length) {
                callback($typeOption);
            }
        }

    });

    return RepositorySelector;
});
