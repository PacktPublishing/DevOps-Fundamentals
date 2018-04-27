define('widget/variable-single-select', [
    'jquery',
    'underscore',
    'backbone',
    'widget/single-select'
], function(
    $,
    _,
    Backbone,
    SingleSelect
) {

    'use strict';

    /* currently only supports pre-bootstrapped data.  No rest end point. */
    var VariableSingleSelect = Backbone.View.extend({
        initialize: function(options) {
            options || (options = {});
            this.singleSelect = new SingleSelect({
                el: this.$el,
                bootstrap: options.bootstrap ? _.map(options.bootstrap, function(variable) {
                    return $.extend(true, variable, {id: variable.key});
                }) : [],
                maxResults: options.maxResults || 5,
                matcher: _.bind(this.matcher, this),
                resultItemTemplate: bamboo.widget.autocomplete.variableItemResult
            });
            this.singleSelect.on('selected', this.handleSelection, this);
        },
        containsMatch: function(str, find) {
            return (str.toLowerCase().indexOf(find.toLowerCase()) > -1);
        },
        matcher: function(variable, query) {
            var matches = false;
            matches = matches || this.containsMatch(variable.get('key'), query);
            return matches;
        },
        handleSelection: function(model) {
            this.$el.trigger('selected', model);
        }
    });

    return VariableSingleSelect;
});
