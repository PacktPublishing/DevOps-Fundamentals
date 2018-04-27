define('page/deployment/view-deployment-preview', [
    'jquery',
    'underscore',
    'backbone',
    'widget/generate-error-messages',
    'util/events',
    'util/ajax'
], function(
    $,
    _,
    Backbone,
    generateErrorMessages,
    events,
    ajax
) {

    'use strict';

    var deploymentPreview = (function() {
        var defaults = {
                versionSoyTemplate: bamboo.page.deployment.execution.releasePreviewWidget,
                versionQueryUrl: AJS.contextPath() + '/rest/api/latest/deploy/preview/version',
                resultQueryUrl: AJS.contextPath() + '/rest/api/latest/deploy/preview/result',
                previousVersionId: null,
                deploymentProjectId: null,
                environmentId: null,
                selectors: {
                    versionPreviewContainerSelector: null,
                    tasksDialogLinkSelector: null
                }
            },
            $versionPreviewContainer,
            $tasksDialogLink,
            options,
            render = function(data, resultsSummary) {
                data.resultsSummary = resultsSummary;
                $versionPreviewContainer.empty().append(options.versionSoyTemplate(data));
                $versionPreviewContainer.find('span.branch-lozenge').tooltip({gravity: 'n'});
                $versionPreviewContainer.find('.lozenge-current').tooltip({gravity: 'n'});
                $versionPreviewContainer.find('.lozenge-last-created').tooltip({gravity: 'n'});
                $tasksDialogLink.show();
            },
            renderArbitraryContent = function($content) {
                $versionPreviewContainer.empty().append($('<p/>').append($content));
                $tasksDialogLink.hide();
            },
            renderError = function(jqXHR, textStatus, errorThrown) {
                var $message = generateErrorMessages(jqXHR, textStatus, errorThrown);
                if (!$message) {
                    $message = $('<p/>').append(AJS.I18n.getText('deployment.execute.preview.version.error'));
                }
                renderArbitraryContent($message);
            },
            update = function(instance, type, eventData) {
                renderArbitraryContent(widget.icons.icon({type: 'loading'}));
                var data = {deploymentProjectId: options.deploymentProjectId};
                if (options.previousVersionId) {
                    data.previousVersionId = options.previousVersionId;
                }
                var url;
                if (type === 'create' && eventData.build && eventData.build.length) {
                    url = options.resultQueryUrl;
                    data.resultKey = eventData.build;
                } else if (type === 'promote' && eventData.release && eventData.release.length) {
                    url = options.versionQueryUrl;
                    data.versionName = eventData.release;
                } else {
                    url = null;
                }
                if (url != null) {
                    ajax({
                        url: url,
                        data: data,
                        dataType: 'json',
                        contentType: 'application/json',
                        cache: false
                    }).success(function(data) {
                        events.EventBus.trigger('deploy:release:rollback', data.rollback);
                        render(data, eventData.resultsSummary);
                    }).error(renderError);
                } else {
                    renderArbitraryContent(AJS.I18n.getText('deployment.execute.preview.version.notselected'));
                }

            },
            showIssueOrCommitsDialog = function($trigger) {
                var $loading = $('<span class="icon icon-loading aui-dialog-content-loading" />'),
                    $dialogContent = $('<div class="deployment-preview-dialog"/>').html($loading),
                    dialog = new AJS.Dialog({
                        width: 840,
                        height: 600,
                        keypressListener: function(e) {
                            if (e.which === jQuery.ui.keyCode.ESCAPE) {
                                dialog.remove();
                                $dialogContent.html($loading);
                            }
                        }
                    });

                dialog.addButton(AJS.I18n.getText('global.buttons.close'), function(dialog) {
                    dialog.remove();
                    $dialogContent.html($loading);
                });
                dialog.addPanel('', $dialogContent);
                dialog.addHeader($trigger.attr('title'));
                ajax({
                    url: $trigger.attr('href'),
                    dataType: 'html',
                    data: {'bamboo.successReturnMode': 'json', decorator: 'nothing', confirm: true},
                    cache: false
                }).done(function(html) {
                    $dialogContent.html(html);
                });
                dialog.show();
            };
        return {
            init: function(opts) {
                options = $.extend(true, defaults, opts);
                $versionPreviewContainer = $(options.selectors.versionPreviewContainerSelector);
                $tasksDialogLink = $(options.selectors.tasksDialogLinkSelector);

                events.EventBus.on('deploy:release', update);
                $('#new-version-preview').on('click', '.issue_url, .commit_url', function(e) {
                    e.preventDefault();
                    showIssueOrCommitsDialog($(this));
                });
                update(null, null, null);
            }
        };
    }());

    return deploymentPreview;
});
