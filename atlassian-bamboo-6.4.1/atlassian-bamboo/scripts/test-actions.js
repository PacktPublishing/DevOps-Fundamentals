BAMBOO.TESTACTIONS = (function ($, _) {
    var toggleFail = function (jqXHR) {
        var json,
                message = 'An error occurred while connecting to Bamboo server. Please refresh the page and try again.';

        try {
            json = $.parseJSON(jqXHR.responseText);
            if (json.errors && json.errors.length) {
                message += "\n\n" + json.errors.join("\n");
            }
        }
        catch (e) {}
        alert(message); //todo: ask Matty how to better present error message
    };

    $(document).delegate(".unlink-test-to-jira-action", "click", function (e) {
        var $button = $(this),
                $toolbarItem = $button.closest(".toolbar-item"),
                isDisabledClass = "disabled",
                jqXHR;

        e.preventDefault();

        if (!$toolbarItem.hasClass(isDisabledClass)) {
            $toolbarItem.addClass(isDisabledClass);
            jqXHR = $.post($button.attr("href"), { "bamboo.successReturnMode": "json" }).fail(toggleFail).always(function () { $toolbarItem.removeClass(isDisabledClass); });

            jqXHR.done(function (json) {
                if (json && json.status && json.status == "OK") {
                    var $tableRows = AJS.$(".test-case-row-"+$button.data('testCaseId'));
                    $tableRows.find(".linked-jira-issue").html('');

                    $tableRows.find(".link-test-to-jira-action").toggleClass("hidden", false);
                    $tableRows.find(".create-jira-issue-for-test-action").toggleClass("hidden", false);
                    $tableRows.find(".unlink-test-to-jira-action").toggleClass("hidden", true);
                } else {
                    toggleFail(jqXHR);
                }
            });
        }
    });

    var renderLinkedJiraIssue = function ($element, issue) {
        $element.html(bamboo.feature.jiraIssueList.singleIssue(issue));
    };

    return {
        onReturnFromLinkingIssueManually: function (json) {
            if (json && json.status && json.status == "OK") {
                var $tableRows = AJS.$(".test-case-row-"+json.testCaseId),
                        $linkedJiraIssueContainers = $tableRows.find(".linked-jira-issue");

                if (json.authenticationRedirectUrl)
                {
                    $linkedJiraIssueContainers.html(bamboo.feature.jiraIssueList.singleIssueOAuth({
                        key: json.issue.key,
                        keyLink: AJS.contextPath() + '/project/jiraRedirect.action?jiraIssueKey=' + json.issue.key,
                        authenticationRedirectUrl: json.authenticationRedirectUrl + '&redirectUrl=' + encodeURIComponent(document.location.href),
                        authenticationInstanceName: json.authenticationInstanceName
                    }));
                }
                else
                {
                    renderLinkedJiraIssue($linkedJiraIssueContainers, json.issue);
                }

                $tableRows.find(".unlink-test-to-jira-action").toggleClass("hidden", false);
                $tableRows.find(".link-test-to-jira-action").toggleClass("hidden", true);
                $tableRows.find(".create-jira-issue-for-test-action").toggleClass("hidden", true);
            } else {
                //show some error alert?... shouldn't happen anyway...
            }
        }
    };

})(jQuery, _);
