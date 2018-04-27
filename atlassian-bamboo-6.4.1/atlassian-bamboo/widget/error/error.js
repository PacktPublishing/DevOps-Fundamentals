define('widget/generate-error-messages', [
    'jquery',
    'underscore'
], function(
    $,
    _
) {

    'use strict';

    var generateErrorMessages = function(jqXHR, textStatus, errorThrown) {
        var $message, data;
        try {
            data = $.parseJSON(jqXHR.responseText);
            if (data.errors && data.errors.length) {
                $message = BAMBOO.buildAUIErrorMessage(data.errors);
            } else if (data.fieldErrors && data.fieldErrors.length) {
                var renderedErrors = [];
                for (var fieldError in data.fieldErrors) {
                    if (data.fieldErrors.hasOwnProperty(fieldError)) {
                        renderedErrors.push(fieldError + ': ' + data.fieldErrors[fieldError]);
                    }
                }
                $message = BAMBOO.buildAUIErrorMessage(renderedErrors);
            } else if (data.messages && data.messages.length) {
                $message = BAMBOO.buildAUIWarningMessage(data.messages);
            }
        } catch (ignore) {}
        return $message;
    };

    return generateErrorMessages;

});
