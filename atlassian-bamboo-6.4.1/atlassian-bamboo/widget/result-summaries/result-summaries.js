define('widget/result-summaries', [
    'underscore',
    'backbone',
    'widget/result-summary'
], function(
    _,
    Backbone,
    ResultSummary
) {

    'use strict';

    var ResultSummaries = Backbone.Collection.extend({
        model: ResultSummary,
        initialize: function(models, options) {
            options || (options = {});
            this.planKey = options.planKey;
        },
        url: function() {
            return AJS.contextPath() + '/ajax/planStatusHistoryNeighbouringSummaries.action?planKey=' + this.planKey;
        },
        parse: function(response) {
            return response.navigableSummaries;
        },
        comparator: function(model) {
            return model.id;
        },
        getMinimumBuildNumber: function() {
            return this.length > 0 ? this.at(0).id : null;
        },
        getIndexOfBuildNumber: function(buildNumber) {
            var model = this.get(buildNumber);
            if (model) {
                return this.indexOf(model);
            } else {
                return -1;
            }
        },
        getMaximumBuildNumber: function() {
            if (this.length == 0) {
                return null;
            }

            return this.last().id;
        },
        purgeActiveBuilds: function() {
            this.remove(this.filter(function(model) {
                return model.attributes.active;
            }));
        },
        getPreviousBuildNumber: function(buildNumber) {
            var i = this.getIndexOfBuildNumber(buildNumber);
            if (i > 0) {
                return this.at(i-1).id;
            }
            return null;
        },
        getNextBuildNumber: function(buildNumber) {
            var i = this.getIndexOfBuildNumber(buildNumber);
            if (i >= 0 && i < this.length - 1) {
                return this.at(i+1).id;
            }
            return null;
        }
    });

    return ResultSummaries;
});
