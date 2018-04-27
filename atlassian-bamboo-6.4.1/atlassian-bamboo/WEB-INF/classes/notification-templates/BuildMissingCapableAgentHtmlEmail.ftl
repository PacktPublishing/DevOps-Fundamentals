[#-- @ftlvariable name="baseUrl" type="java.lang.String" --]
[#-- @ftlvariable name="build" type="com.atlassian.bamboo.chains.Chain" --]
[#-- @ftlvariable name="buildKey" type="java.lang.String" --]
[#-- @ftlvariable name="buildNumber" type="int" --]
[#-- @ftlvariable name="commits" type="java.util.List<com.atlassian.bamboo.commit.CommitContext>" --]
[#-- @ftlvariable name="branchStatus" type="com.atlassian.bamboo.chains.branches.BranchStatusLinkInfo" --]

[#include "notificationCommonsHtml.ftl"]
[#assign customStatusMessage]has been queued, but there's no agent capable of building it[/#assign]

[@templateOuter baseUrl=baseUrl statusMessage=customStatusMessage]

    [@showCommitsNoBuildResult commits baseUrl buildKey /]

    [@showActions buttons=true]
        [@addActionButton name="View online" url="${baseUrl}/browse/${buildKey}/log" primary=true /]
        [#if branchStatus.showLink]
            [@addActionButton name="Branch status" url="${baseUrl}/branchStatus/${branchStatus.path}" /]
        [/#if]
        [@addMutativeAction name="Stop build"  url="${baseUrl}/build/admin/stopPlan.action?planKey=${buildKey}" /]
    [/@showActions]

[/@templateOuter]