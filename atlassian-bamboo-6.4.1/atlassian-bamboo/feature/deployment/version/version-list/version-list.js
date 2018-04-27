define('feature/deployment-version-list', [
    'jquery',
    'underscore'
], function(
    $,
    _
) {

    'use strict';

    function DeploymentVersionList(selector, projectId, options) {
        options = options || {};

        this.projectId = projectId;
        options.url = AJS.contextPath() + '/rest/api/latest/deploy/project/' + this.projectId + '/versions';

        BAMBOO.InfiniteTable.call(this, selector, options);
    }
    DeploymentVersionList.prototype = BAMBOO.InfiniteTable.prototype;

    DeploymentVersionList.prototype.attachNewContent = function(data, attachmentMethod) {
        var deploymentProjectId = this.projectId;
        this.$tbody[attachmentMethod](_.map(data.versions, function(version) {
            return bamboo.feature.deployment.version.versionList.item({
                deploymentProjectId: deploymentProjectId,
                version: version
            });
        }).join(''));

        if ((data.size == (data['start-index'] + data['max-result']))) {
            $('<p class="no-more-results"/>').text(AJS.I18n.getText('global.results.no.more')).insertAfter(this.$table);
        }
    };

    return DeploymentVersionList;

});
