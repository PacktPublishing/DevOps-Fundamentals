define('page/deployment/deployment-version', [
    'jquery',
    'underscore',
    'util/ajax'
], function(
    $,
    _,
    ajax
) {

    'use strict';

    var
        markApprovedSelector = '.mark-approved',
        markBrokenSelector = '.mark-broken',
        markIncompleteSelector = '.mark-incomplete',
        versionStatusDetailsSelector = '.version-status-details',
        versionLozengeContainerSelector = '.version-lozenge-container',
        userAndTimeStampContainerSelector = '.detailed-version-info-container',
        versionId;

    function updateVersionStatus(data) {
        clearButtonStates();
        var $versionLozengeContainer = $(versionLozengeContainerSelector);
        $versionLozengeContainer.empty();

        $(widget.status.deploymentVersionStatus({
            deploymentVersionState: data.versionState
        })).appendTo($versionLozengeContainer);

        var $userAndTimeStampContainer = $(userAndTimeStampContainerSelector);
        $userAndTimeStampContainer.empty();
        $(widget.status.deploymentVersionStatusInfo({
            deploymentVersionState: data.versionState,
            userName: data.userName,
            displayName: data.displayName,
            avatar: data.gravatarUrl
        })).appendTo($userAndTimeStampContainer);

        $(versionStatusDetailsSelector).toggleClass(
            'version-status-hidden', data.versionState != 'APPROVED' && data.versionState != 'BROKEN'
        );

        $(markApprovedSelector).attr('aria-pressed', data.versionState == 'APPROVED');
        $(markBrokenSelector).attr('aria-pressed', data.versionState == 'BROKEN');
    }

    function wasPressed(button) {
        return $(button).attr('aria-pressed') !== 'true';
    }

    function markApproved() {
        markVersion('APPROVED', wasPressed(this));
    }

    function markBroken() {
        markVersion('BROKEN', wasPressed(this));
    }

    function markVersion(status, enabled) {
        ajax({
            url: AJS.contextPath() + '/rest/api/latest/deploy/version/'
                + versionId + '/status/' + (enabled ? status : 'UNKNOWN'),
            dataType: 'json',
            type: 'POST'
        }).done(updateVersionStatus);
    }

    function clearButtonStates() {
        $(markApprovedSelector)
            .add($(markBrokenSelector))
            .add($(markIncompleteSelector))
            .removeAttr('aria-pressed');
    }

    function DeploymentVersion(options) {
        versionId = options.versionId;

        $(document)
            .on('click', markApprovedSelector, markApproved)
            .on('click', markBrokenSelector, markBroken);

        BAMBOO.simpleDialogForm({
            trigger: '.delete-deployment-version',
            dialogWidth: 600,
            dialogHeight: 250,
            success: redirectAfterReturningFromDialog
        });
    }

    return DeploymentVersion;

});
