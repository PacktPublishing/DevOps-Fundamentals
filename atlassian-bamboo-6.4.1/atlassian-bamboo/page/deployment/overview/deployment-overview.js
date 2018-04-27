define('page/deployment/deployment-overview', [
    'jquery',
    'underscore'
], function(
    $,
    _
) {

    'use strict';

    var Overview = {};

    Overview.AddProject = function(data) {
        eve('deployment.project.add', this, data.project);
    };

    return Overview;
});
