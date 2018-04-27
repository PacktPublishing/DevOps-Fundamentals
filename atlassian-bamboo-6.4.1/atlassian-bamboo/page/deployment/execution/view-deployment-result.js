define('page/deployment/view-deployment-result', [
    'jquery',
    'underscore',
    'widget/page-visibility-manager',
    'util/ajax'
], function(
    $,
    _,
    pageVisibilityManager,
    ajax
) {

    'use strict';

    var LifeCycleState = {
        FINISHED: 'FINISHED',
        NOT_BUILT: 'NOT_BUILT'
    };

    var deploymentResult = (function() {
        var opts = {
                resultContainerSelector: null,
                resultStatusRibbonSelector: null,
                linesToDisplaySelector: null,
                resultUrl: null,
                environment: null,
                lifeCycleState: null,
                reloadUrl: null
            },
            linesToDisplay = 50,
            updateTimeout,
            refreshOnFinish = function(result) {
                /* Refresh the whole page if the lifecycle state changes from one of the running states to one of the finished states.  No need to refresh otherwise*/
                if (result.lifeCycleState != opts.lifeCycleState && (result.lifeCycleState == LifeCycleState.FINISHED || result.lifeCycleState == LifeCycleState.NOT_BUILT)) {
                    window.location = opts.reloadUrl;
                }
            },
            render = function(result) {
                $(opts.resultStatusRibbonSelector).html(bamboo.layout.resultDeploymentStatusRibbon({deploymentResult: result, environment: opts.environment}));
                $(opts.resultContainerSelector).html(bamboo.page.deployment.project.viewDeploymentResult({deploymentResult: result, environment: opts.environment, logLinesToShow: linesToDisplay}));
                $(opts.resultContainerSelector).find('span.branch-lozenge').tooltip({gravity: 'n'});
            },
            scheduleNextUpdate = function(result, textStatus, jqXHR) {
                cancelNextUpdate();
                var delayBeforeUpdate = ((typeof textStatus === 'undefined' || textStatus == 'success') ? 5000 : 30000);
                if (result.lifeCycleState != LifeCycleState.FINISHED && result.lifeCycleState != LifeCycleState.NOT_BUILT) {
                    updateTimeout = setTimeout(update, delayBeforeUpdate);
                }
            },
            cancelNextUpdate = function() {
                clearTimeout(updateTimeout);
            },
            update = function() {
                cancelNextUpdate();
                if (!pageVisibilityManager.isPageVisible()) {
                    return;
                }

                ajax({
                    url: opts.resultUrl,
                    data: {
                        'max-results': linesToDisplay
                    },
                    dataType: 'json',
                    contentType: 'application/json',
                    cache: false
                }).done(refreshOnFinish, render).always(scheduleNextUpdate);
            };
        return {
            init: function(options) {
                $.extend(true, opts, options);

                /* Get our default in line with what was set previously */
                if (opts.linesToDisplaySelector) {
                    var $linesToDisplay = $(opts.linesToDisplaySelector);
                    if ($linesToDisplay.length) {
                        linesToDisplay = $linesToDisplay.val();
                    }
                    $(opts.resultContainerSelector).on('change', opts.linesToDisplaySelector, function() {
                        linesToDisplay = $(this).val();
                        saveCookie('BAMBOO-MAX-DISPLAY-LINES', linesToDisplay, 365);
                        update();
                    });
                }

                pageVisibilityManager.setUp(update, cancelNextUpdate);
            }
        }
    }());

    BAMBOO.simpleDialogForm({
        trigger: '.delete-deployment-result',
        dialogWidth: 600,
        dialogHeight: 250,
        success: redirectAfterReturningFromDialog
    });

    return deploymentResult;
});
