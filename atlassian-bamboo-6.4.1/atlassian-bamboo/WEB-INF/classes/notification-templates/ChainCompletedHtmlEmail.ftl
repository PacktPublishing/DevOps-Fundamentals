[#-- @ftlvariable name="triggerReasonDescription" type="java.lang.String" --]
[#-- @ftlvariable name="baseUrl" type="java.lang.String" --]
[#-- @ftlvariable name="build" type="com.atlassian.bamboo.chains.Chain" --]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]
[#-- @ftlvariable name="chainTestResults" type="com.atlassian.bamboo.chains.ChainFilteredTestResults" --]
[#-- @ftlvariable name="executedJobs" type="int" --]
[#-- @ftlvariable name="branchStatus" type="com.atlassian.bamboo.chains.branches.BranchStatusLinkInfo" --]
[#include "notificationCommons.ftl"]
[#include "notificationCommonsHtml.ftl" ]
[#assign totalJobCount = executedJobs/]
[#assign failingJobCount = buildSummary.failedJobResults?size/]

[@templateOuter baseUrl=baseUrl]

    [@displayTriggerReason /]
    <p class="tests-summary">
        [#if buildSummary.successful]
            [#if totalJobCount > 1]
                [#if buildSummary.testResultsSummary.totalTestCaseCount == 0]
                    All <strong>${totalJobCount}<strong> jobs passed[#t]
                [#else]
                    All <strong>${totalJobCount}</strong> jobs passed with <strong>${buildSummary.testResultsSummary.successfulTestCaseCount}</strong> tests in total.[#t]
                [/#if]
            [#else]
                [#if buildSummary.testResultsSummary.totalTestCaseCount == 0]
                    No tests executed.
                [#else]
                    <strong>${buildSummary.testResultsSummary.successfulTestCaseCount}</strong> tests in total.
                [/#if]
            [/#if]
        [#else]
            [@displayBuildFailureMessage buildSummary totalJobCount/]
        [/#if]
    </p>

    [#list ctx.getWebPanelsForResultsSummary("notification.completedbuild.html", buildSummary) as webpanel]
    ${webpanel}
    [/#list]

    [@showFailingJobs buildSummary baseUrl /]
    [@showCommits buildSummary baseUrl /]
    [@showChainTests buildSummary chainTestResults baseUrl /]

    [@showActions buttons=true]
        [@addActionButton name="View build" url="${baseUrl}/browse/${buildSummary.planResultKey}" primary=true/]
        [#if branchStatus.showLink]
            [@addActionButton name="Branch status" url="${baseUrl}/branchStatus/${branchStatus.path}" /]
        [/#if]
        [@addAction name="Add comment" url="${baseUrl}/browse/${buildSummary.planResultKey}?commentMode=true"/]
    [/@showActions]

[/@templateOuter]