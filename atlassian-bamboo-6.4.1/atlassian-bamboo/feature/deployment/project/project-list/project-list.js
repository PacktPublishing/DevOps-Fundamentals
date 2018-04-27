define('feature/deployment-project-list', [
    'jquery',
    'underscore',
    'brace',
    'model'
], function(
    $,
    _,
    Brace,
    model
) {

    'use strict';

    var DeploymentProjectListCollection = Brace.Collection.extend({

        model: model.DeploymentProjectWithEnvironmentStatuses,

        fetchUrl: [
            AJS.contextPath(),
            'rest/api/latest/deploy/dashboard'
        ].join('/'),

        url: function() {
            return this.fetchUrl;
        },

        comparator: function(projectWithEnvironmentStatus) {
            return projectWithEnvironmentStatus.getDeploymentProject().getName().toLowerCase();
        },

        initialize: function(bootstrap, options) {
            if (options.fetchUrl) {
                this.fetchUrl = options.fetchUrl;
            }
        }

    });

    var DeploymentProjectList = Brace.View.extend({

        initialize: function(options) {
            this.options.bootstrap = options.bootstrap || [];
            this.collection = new DeploymentProjectListCollection(
                this.options.bootstrap, {
                    fetchUrl: options.fetchUrl
                }
            );

            this.collection.on('reset', _.bind(this.render, this));
            this._updateTimeoutSuccess = options.updateTimeoutSuccess || 20000;
            this._updateTimeoutFailure = options.updateTimeoutFailure || 60000;

            if (!options.bootstrap.length) {
                this.onUpdate();
            }
        },

        render: function() {
            this.$el.html(bamboo.feature.deployment.project.projectList.projectList({
                projectsWithEnvironmentStatuses: this.collection.toJSON(),
                showProject: this.options.showProject,
                currentUrl: this.options.currentUrl
            }));

            this.$el.find('td.deployment > a').tooltip({aria: true});
            this.$el.find('span.icon-deploy-success, span.icon-deploy-fail, span.aui-icon-deploy-success, span.aui-icon-deploy-fail').tooltip({gravity: 'n'});

            return this;
        },

        onUpdate: function() {
            return this.collection.fetch({
                cache: false
            })
                .done(_.bind(this.render, this))
                .fail(_.bind(this.onError, this))
                .always(_.bind(this.onScheduleNext, this));
        },

        onError: function(jqXHR, textStatus, errorThrown) {
            this.$el.children('.icon-loading, .aui-message').remove();
            this.$el.prepend(AJS.messages.warning({
                title: AJS.I18n.getText('error.refresh.noResponse'),
                closeable: false
            }));
        },

        /**
         * Schedules next poll
         * @param {Object} data the data from a successful request, or the jqXHR object for a failed request
         * @param {String} textStatus
         * @param {Object|String} jqXHR the jqXHR object for a successful request, or the errorThrown for a failed request
         */
        onScheduleNext: function(data, textStatus, jqXHR) {
            clearTimeout(this._timeout);

            var delayBeforeUpdate = ((typeof textStatus === 'undefined' || textStatus === 'success') ?
                this._updateTimeoutSuccess : this._updateTimeoutFailure);

            this._timeout = setTimeout(
                _.bind(this.onUpdate, this),
                delayBeforeUpdate
            );
        }

    });

    return DeploymentProjectList;
});
