define('widget/autocomplete-ajax', [
    'jquery',
    'underscore',
    'widget/autocomplete',
    'util/events',
    'util/ajax',
    'util/errors'
], function(
    $,
    _,
    Autocomplete,
    events,
    ajax,
    errors
) {

    'use strict';

    var AutocompleteAjax = Autocomplete.extend({

        mixins: [
            events.EventBusMixin
        ],

        initialize: function(options) {
            this.params = $.extend({
                'max-results': 10
            }, this.params || {});

            if (_.isFunction(this.onFormatSelection)) {
                options.formatSelection = _.bind(this.onFormatSelection, this);
            }

            if (_.isFunction(this.onFormatResult)) {
                options.formatResult = _.bind(this.onFormatResult, this);
            }

            options.ajax.quietMillis = options.ajax.quietMillis || 320;

            if (_.isUndefined(options.cache) || !!options.cache) {
                options.ajax.resultsCallback = options.ajax.results;
                options.ajax.results = null;

                options.query = _.debounce(
                    _.bind(this.queryAjaxCache, this),
                    options.ajax.quietMillis
                );

                if (!options.ajax.params) {
                    if (_.isFunction(this.onRemoteData)) {
                        options.ajax.params = {
                            error: _.bind(this.onRemoteData, this)
                        };
                    }
                    else {
                        options.ajax.params = {
                            error: _.bind(function(jqXHR, textStatus, errorThrown) {
                                this.$el.auiSelect2('close');
                                errors(
                                    jqXHR, textStatus, errorThrown
                                );
                            }, this)
                        };
                    }
                }
            }

            Autocomplete.prototype.initialize.apply(
                this, [options || {}]
            );
        },

        queryAjaxCache: function(query) {
            this.cache = this.cache || {
                initial: {},
                term: {}
            };

            var term = $.trim(query.term);

            query.key = JSON.stringify(
                this.settings.ajax.data(term, query.page || 1, true)
            );

            var cache = (term.length) ?
                this.cache.term[query.key] :
                this.cache.initial[query.key];

            if (!_.isEmpty(cache)) {
                query.callback(cache);
                return;
            }

            this.settings.ajax.results = _.bind(function(data, page) {
                var response = this.settings.ajax
                    .resultsCallback(data, page);

                if (!response.results.length && this.settings.ajax.empty) {
                    response = {
                        results: this.settings.ajax.empty.call(this, query.term),
                        more: false
                    };
                }

                if (term) {
                    this.cache.term[query.key] = response;
                }
                else {
                    this.cache.initial[query.key] = response;
                }

                return response;
            }, this);

            window.Select2.query.ajax($.extend({
                transport: ajax
            }, this.settings.ajax))(query);
        },

        addQueryCache: function(request, data) {
            var key = JSON.stringify(request);
            data = data || this.data;

            if (!key.query || !key.query.length) {
                this.cache.initial[key] = data;
            }
            else {
                this.cache.term[key] = data;
            }

            return this;
        },

        clearQueryCache: function() {
            this.cache = {
                initial: {},
                term: {}
            };

            return this;
        }

    });

    return AutocompleteAjax;

});
