(function(window) {
    'use strict';

    _.extend(Marionette.Renderer, {

        render: function(template, data, context) {
            if (!template) {
                throw new window.Marionette.Error({
                    name: 'TemplateNotFoundError',
                    message: 'Cannot render the template since its false, null or undefined.'
                });
            }

            var templateFunc = _.isFunction(template) ?
                template : window.Marionette.TemplateCache.get(template);

            return templateFunc.call(context, data);
        }

    });

    define('marionette', function () {
        return window.Marionette;
    });

})(window || this);
