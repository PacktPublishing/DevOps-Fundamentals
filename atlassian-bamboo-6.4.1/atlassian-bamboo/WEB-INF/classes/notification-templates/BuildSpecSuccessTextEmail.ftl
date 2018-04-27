[#-- @ftlvariable name="commits" type="java.util.List<com.atlassian.bamboo.commit.CommitContext>" --]
[#-- @ftlvariable name="affectedBuilds" type="java.util.List<com.atlassian.bamboo.notification.rss.RssAffectedPlan>" --]
[#-- @ftlvariable name="affectedDeployments" type="java.util.List<com.atlassian.bamboo.notification.rss.RssNotification.RssAffectedDeployment>" --]

[#include "notificationCommons.ftl"]
[#include "notificationCommonsText.ftl" ]
[@notificationTitleText "Specs execution successful"/]

[@showCommits commits=commits limit=false /]

[@showAllSpecUpdatedBuilds affectedBuilds=affectedBuilds /]
[@showAllSpecUpdatedDeployments affectedDeployments=affectedDeployments /]
[@showEmailFooter /]