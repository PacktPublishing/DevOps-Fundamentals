[#-- @ftlvariable name="commits" type="java.util.List<com.atlassian.bamboo.commit.CommitContext>" --]
[#-- @ftlvariable name="affectedBuilds" type="java.util.List<com.atlassian.bamboo.notification.rss.RssAffectedPlan>" --]
[#-- @ftlvariable name="affectedDeployments" type="java.util.List<com.atlassian.bamboo.notification.rss.RssNotification.RssAffectedDeployment>" --]

[#include "notificationCommons.ftl"]
[#include "notificationCommonsText.ftl" ]
[@notificationTitleText "Error in Bamboo Specs"/]

[@showCommits commits=commits limit=false /]

[@showAllSpecFailedBuilds failedBuilds=affectedBuilds /]
[@showAllSpecFailedDeployments failedDeployments=affectedDeployments /]
[@showEmailFooter /]
