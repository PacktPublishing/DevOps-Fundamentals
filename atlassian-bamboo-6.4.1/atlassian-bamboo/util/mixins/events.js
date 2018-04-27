define('util/events', [
    'underscore',
    'backbone',
    'exports'
], function(_, Backbone, exports) {

    'use strict';

    var EventBus = new Backbone.Wreqr.EventAggregator();
    var EventBusMixin = {

        onEvent: function(key, callback, object) {
            var handler = function(value, callback, object) {
                EventBus.on(value, _.bind(callback, object));
            };

            if (_.isArray(key)) {
                _.each(key, _.bind(function(value) {
                    handler(value, callback, object || this);
                }, this));
            }
            else {
                handler(key, callback, object || this);
            }
        },

        triggerEvent: function(key) {
            EventBus.trigger.apply(EventBus,
                [key, this].concat(
                    Array.prototype.slice.call(arguments, 1)
                )
            );
        },

        offEvent: function(events) {
            if (_.isArray(events)) {
                _.each(events, function(event) {
                    EventBus.off(event);
                });
            }
            else {
                EventBus.off(events);
            }
        },

        offEventNamespace: function(namespace) {
            if (namespace.length) {
                _.each(_.keys(EventBus._events), _.bind(function(event) {
                    if (event.indexOf(namespace + ':') === 0) {
                        this.offEvent(event);
                    }
                }, this));
            }
        },

        proxyEvents: function(key, events, object, bindMethod) {
            var scope = object || this, self = this;
            var proxyMethod = (bindMethod) ? scope[bindMethod] : scope.on;

            _.each(events, function(event) {
                proxyMethod.apply(scope, [event, function() {
                    self.triggerEvent(
                        [key, event].join(':'), scope
                    );
                }]);
            });
        }

    };

    exports.EventBus = EventBus;
    exports.EventBusMixin = EventBusMixin;

});

/**
 * Export functionality onto Bamboo prototype.
 * To be removed in 6.0
 * @deprecated
 */
if (AJS.namespace) {
    AJS.namespace('Bamboo.EventBus', null, require('util/events').EventBus);
    AJS.namespace('Bamboo.EventBusMixin', null, require('util/events').EventBusMixin);
}
