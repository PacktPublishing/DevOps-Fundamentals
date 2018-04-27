define('widget/result-summary', [
    'underscore',
    'backbone'
], function(
    _,
    Backbone
) {

    'use strict';

    var ResultSummary = Backbone.Model.extend({
        idAttribute: 'buildNumber'
    });


    return ResultSummary;
});
