[#-- @ftlvariable name="baseUrl" type="java.lang.String" --]
[#-- @ftlvariable name="currentlyBuilding" type="com.atlassian.bamboo.v2.build.CurrentlyBuilding" --]
[#-- @ftlvariable name="buildKey" type="java.lang.String" --]
[#-- @ftlvariable name="buildNumber" type="int" --]
[#-- @ftlvariable name="commits" type="java.util.List<com.atlassian.bamboo.commit.CommitContext>" --]
[#-- @ftlvariable name="buildAgent" type="com.atlassian.bamboo.v2.build.agent.BuildAgent" --]
[#-- @ftlvariable name="durationUtils" type="com.atlassian.bamboo.utils.DurationUtils" --]
[#-- @ftlvariable name="branchStatus" type="com.atlassian.bamboo.chains.branches.BranchStatusLinkInfo" --]

[#include "notificationCommonsHtml.ftl"]
[#assign customStatusMessage]may have hung[/#assign]

[@templateOuter baseUrl=baseUrl statusMessage=customStatusMessage]

    <p class="build-hung-details">[@ui.displayBuildHungDurationInfoHtml currentlyBuilding.elapsedTime, currentlyBuilding.averageDuration, currentlyBuilding.buildHangDetails /]</p>
    [#if buildAgent?has_content]<p class="agent-info">Running on agent <strong>${buildAgent.name?html}</strong></p>[/#if]

    [@showCommitsNoBuildResult commits baseUrl buildKey /]

    [@showLogs lastLogs baseUrl buildKey /]

    [@showActions buttons=true]
        [@addActionButton name="View online" url="${baseUrl}/browse/${buildKey}/log" primary=true/]
        [#if branchStatus.showLink]
            [@addActionButton name="Branch status" url="${baseUrl}/branchStatus/${branchStatus.path}" /]
        [/#if]
        [@addMutativeAction name="Stop build"  url="${baseUrl}/build/admin/stopPlan.action?planKey=${buildKey}" /]
    [/@showActions]

[/@templateOuter]