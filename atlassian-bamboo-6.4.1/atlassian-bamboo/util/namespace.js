/**
 * Get/set the value at a compound namespace,
 * gracefully adding values where missing.
 *
 * @param {string} namespace
 * @param {Object} [context=window]
 * @param {Object} [value={}]
 * @deprecated
 */
AJS.namespace = function (namespace, context, value) {
    var names = namespace.split(".");
    context = context || window;
    for (var i = 0, n = names.length - 1; i < n; i++) {
        var x = context[names[i]];
        context = (x != null) ? x : context[names[i]] = {};
    }
    context[names[i]] = value || context[names[i]] || {};
    return context[names[i]];
};
