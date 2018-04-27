[#-- @ftlvariable name="baseUrl" type="java.lang.String" --]
[#-- @ftlvariable name="changeSetUrl" type="java.lang.String" --]
[#-- @ftlvariable name="commits" type="java.util.List<com.atlassian.bamboo.commit.CommitContext>" --]
[#-- @ftlvariable name="affectedBuilds" type="java.util.List<com.atlassian.bamboo.notification.rss.RssAffectedPlan>" --]
[#-- @ftlvariable name="affectedDeployments" type="java.util.List<com.atlassian.bamboo.notification.rss.RssNotification.RssAffectedDeployment>" --]
[#-- @ftlvariable name="projectsNames" type="java.util.Map<String, String>" --]
[#-- @ftlvariable name="repositoriesIds" type="java.util.Map<String, Long>" --]

[#include "notificationCommons.ftl"]
[#include "notificationCommonsHtml.ftl" ]

<style type="text/css">
    #email-actions {
        border-top: 0;
        margin: 0;
    }
</style>

[#assign notificationTitleHtml]
    [@notificationTitleSpecError baseUrl=baseUrl /]
[/#assign]

[@templateBase baseUrl=baseUrl notificationTitleHtml=notificationTitleHtml]
    [@showAllCommits commits=commits baseUrl=baseUrl /]
    [@showAllSpecFailedBuilds failedBuilds=affectedBuilds baseUrl=baseUrl projectsNames=projectsNames repositoriesIds=repositoriesIds/]
    [@showAllSpecFailedDeployments failedDeployments=affectedDeployments baseUrl=baseUrl /]

    [#if commits?has_content]
        [@showActions buttons=true]
            [@addActionButton
                name="View error logs"
                url="${baseUrl}${changeSetUrl}"
                primary=true/]
        [/@showActions]
    [/#if]
[/@templateBase]
