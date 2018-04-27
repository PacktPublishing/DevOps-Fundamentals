[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.repository.DeleteLinkedRepository" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.repository.DeleteLinkedRepository" --]
<html>
<head>
[@ui.header pageKey=title title=true/]
    <meta name="decorator" content="focusTask">
</head>
<body>
[#assign cancelUri][#if repositoryDashboardOn]/vcs/viewAllRepositories.action[#else]/admin/configureLinkedRepositories.action[/#if][/#assign]

[@ww.form   action="deleteLinkedRepository"
namespace="/admin"
submitLabelKey="global.buttons.delete"
cancelUri=cancelUri]

    [@ui.messageBox type="warning" titleKey="repository.delete.confirm" /]

    [#import "/build/common/repositoryCommon.ftl" as rc]
    [@rc.viewGlobalRepositoryUsages planUsingRepository hiddenPlansUsingRepositoryCount environmentUsingRepository hiddenEnvironmentsUsingRepositoryCount /]
    [@ww.hidden name="repositoryId"/]
[/@ww.form]
</body>