define('widget/autocomplete-static', [
    'jquery',
    'underscore',
    'widget/autocomplete'
], function(
    $,
    _,
    Autocomplete
) {

    'use strict';

    var AutocompleteStatic = Autocomplete.extend({

        initialize: function(options) {
            var settings = $.extend({
                data: [],
                query: function(query) {
                    var pageSize = options.pageSize || 10;
                    var results = _.filter(this.data, function(e) {
                        return (query.text === '' ||
                            e.text.toUpperCase().indexOf(
                                query.term.toUpperCase()
                            ) >= 0
                        );
                    });

                    query.callback({
                        results: results.slice(Math.max(query.page - 1, 0) * pageSize, query.page * pageSize),
                        more: results.length >= query.page * pageSize
                    });

                    results = null;
                    pageSize = null;
                }
            }, options || {});

            if (_.isFunction(this.onFormatSelection)) {
                settings.formatSelection = _.bind(this.onFormatSelection, this);
            }

            if (_.isFunction(this.onFormatResult)) {
                settings.formatResult = _.bind(this.onFormatResult, this);
            }

            Autocomplete.prototype.initialize.apply(
                this, [settings]
            );
        }

    });

    return AutocompleteStatic;
});
