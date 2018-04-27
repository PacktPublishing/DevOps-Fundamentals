define('widget/plan-single-select', [
    'jquery',
    'underscore',
    'brace',
    'backbone',
    'widget/single-select',
    'util/events'
], function(
    $,
    _,
    Brace,
    Backbone,
    SingleSelect,
    events
) {
    'use strict';

    return Brace.View.extend({
        mixins: [events.EventBusMixin],
        initialize: function(options) {
            options || (options = {});

            var PlanSingleSelect = SingleSelect.extend({
                getDisplayValue: this.getFilterValue
            });

            this.singleSelect = new PlanSingleSelect({
                el: this.$el,
                bootstrap: options.bootstrap || [],
                maxResults: options.maxResults || 10,
                matcher: _.bind(this.matcher, this),
                parser: this.parser,
                resultItemTemplate: bamboo.widget.autocomplete.planItemResult,
                queryEndpoint: AJS.contextPath() + '/rest/api/latest/search/plans',
                queryParamKey: 'searchTerm',
                queryData: options.queryData || { fuzzy: true }
            });

            if (this.singleSelect.queryInput.val()) {
                this.singleSelect.requestMatchesQuietly(_.bind(function() {
                    if (this.singleSelect.datasource.length) {
                        this.singleSelect.setValue(this.singleSelect.datasource.models[0]);
                    }
                }, this));
            }

            this.onEvent('branch:empty', this.onHideBranchOptions);
            this.singleSelect.on('selected', this.onHandleSelection, this);
            this.singleSelect.queryInput.on('change', this.onHandleSelection, this);
        },

        /**
         * Normalizes the string for searching. Should be applied both for query string and for result string returned
         * from server.
         *
         * Note: this widget uses client-side matching whenever possible, avoiding unnecessary server requests. Because
         * of that, search result filtering on client side must not be stricter than filtering on server side. The
         * optimal solution is to keep this normalization method and server normalization method in sync.
         *
         * @param str string to normalize
         * @returns {string} normalized string
         */
        normalizeString: function(str) {
            return (str || '').toLowerCase().replace(/[\u203A `~!@#$%^&*()_|+\-=?;:'",.<>\{\}\[\]\\\/]+/g, ' ');
        },

        containsMatch: function(str, find) {
            return this.normalizeString(str).indexOf(this.normalizeString(find)) > -1;
        },
        matcher: function(plan, query) {
            return this.containsMatch(this.getFilterValue(plan), query);
        },
        parser: function(response) {
            return _.map(response.searchResults, function(result) {
                return result.searchEntity;
            });
        },
        getFilterValue: function(model) {
            // > character is not escaped for a reason
            return model.get('projectName') + ' › ' + model.get('planName');
        },
        onHandleSelection: function(model) {
            this.triggerEvent('plan:selected', model);

            if (model instanceof Backbone.Model) {
                this.$el.parents('.field-group').next().show();
            }
        },
        onHideBranchOptions: function() {
            this.$el.parents('.field-group').next().hide();
        }
    });
});
