define('page/deployment/view-deployment-project', [
    'jquery',
    'underscore'
], function(
    $,
    _
) {

    'use strict';

    var viewDeploymentProject = (function() {
        var hiddenClass = 'hidden';
        $(document).on('click', '#show-all-version-history', function() {
            $('#deployment-project-version-history').find('.' + hiddenClass).removeClass(hiddenClass);
            $(this).remove();
        });
    }());

    return viewDeploymentProject;
});
