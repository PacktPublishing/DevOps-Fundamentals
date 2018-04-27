define('feature/deployment-result-list', [
    'jquery',
    'underscore'
], function(
    $,
    _
) {

    'use strict';

    function DeploymentResultList(selector, environmentId, options) {
        options = options || {};

        this.environmentId = environmentId;
        this.currentUrl = document.URL.split(AJS.contextPath())[1];

        options.url = AJS.contextPath() + '/rest/api/latest/deploy/environment/' + this.environmentId + '/results';
        BAMBOO.InfiniteTable.call(this, selector, options);
    }

    DeploymentResultList.prototype = BAMBOO.InfiniteTable.prototype;
    DeploymentResultList.prototype.attachNewContent = function(data, attachmentMethod) {
        this.$tbody[attachmentMethod](_.map(data.results, _.bind(function(result) {
            return bamboo.feature.deployment.result.resultList.item({
                deploymentResult: result,
                environmentId: this.environmentId,
                currentUrl: this.currentUrl
            });
        }, this)).join(''));

        if ((data.size == (data['start-index'] + data['max-result']))) {
            $('<p class="no-more-results"/>').text(AJS.I18n.getText('global.results.no.more')).insertAfter(this.$table);
        }
    };

    return DeploymentResultList;

});
