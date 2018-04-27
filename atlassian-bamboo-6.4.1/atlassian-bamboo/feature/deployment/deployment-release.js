define('feature/deployment-release', [
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

    var DeploymentRelease = Brace.View.extend({

        mixins: [events.EventBusMixin],

        initialize: function(options) {
            this.data = {
                create: {},
                promote: {},
                rollback: false
            };

            if (options.event) {
                this.data[options.event] = options.data || {};
                this.triggerWrapperEvent(options.event, true);
            }

            this.onEvent([
                'release:change',
                'release:change:initial'
            ], this.onReleaseChange);

            this.onEvent([
                'branch:change',
                'branch:change:initial'
            ], this.onBranchChange);

            this.onEvent([
                'build:change',
                'build:change:initial'
            ], this.onBuildChange);

            this.onEvent('deploy:release:warning', this.onToggleWarning);
            this.onEvent('deploy:release:rollback', this.onToggleRollbackWarning);

            $(document).on('change',
                'form input:radio[name="releaseTypeOption"]',
                _.bind(this.onTypeChange, this)
            );
        },

        onBranchChange: function(instance) {
            switch (instance.$el.attr('id')) {
                case 'newReleaseBranchKey':
                    this.data.create.branch = $.trim(instance.$el.val());
                    this.triggerWrapperEvent('create');
                    break;
                case 'promoteReleaseBranchKey':
                    this.triggerWrapperEvent('promote');
                    break;
            }
        },

        onBuildChange: function(instance) {
            switch (instance.$el.attr('id')) {
                case 'newReleaseBuildResult':
                    this.data.create.build = $.trim(instance.$el.val());
                    this.data.create.resultsSummary = instance.getSelectedData();
                    this.triggerWrapperEvent('create');
                    break;
            }
        },

        onReleaseChange: function(instance) {
            switch (instance.$el.attr('id')) {
                case 'promoteVersion':
                    this.data.promote.release = instance.$el.val();
                    this.triggerWrapperEvent('promote');
                    break;
            }
        },

        onTypeChange: function() {
            var type = $('form input:radio[name="releaseTypeOption"]:checked').val();
            var warning = $('#rollbackWarning');

            type = $.trim(type).toLowerCase();

            if (type === 'create') {
                warning.toggleClass('hidden', !this.data.rollback);
            }

            this.triggerWrapperEvent(type);
        },

        onToggleWarning: function(instance) {
            var warning = $('#emptyBuildResults');
            var container = instance.$el.parents('.radio:first');

            if (this.data.create.build) {
                this.triggerEvent('build:show', container);
                this.triggerEvent('release:show', container);

                warning.addClass('hidden');
            }
            else {
                this.triggerEvent('build:hide', container);
                this.triggerEvent('release:hide', container);

                warning.removeClass('hidden');
            }
        },

        onToggleRollbackWarning: function(state) {
            this.data.rollback = state;

            $('#rollbackWarning').toggleClass(
                'hidden', !state
            );
        },

        getSelectedType: function() {
            return $('form input:radio[name="releaseTypeOption"]:checked')
                .val().toLowerCase();
        },

        triggerWrapperEvent: function(event, force) {
            if (force || this.getSelectedType() === event) {
                this.lastEvent = [
                    'deploy:release',
                    event, this.data[event]
                ];

                setTimeout(_.bind(function() {
                    if (this.lastEvent) {
                        this.triggerEvent.apply(this, this.lastEvent);
                        this.lastEvent = null;
                    }
                }, this), 100);
            }
        }

    });

    return DeploymentRelease;
});
