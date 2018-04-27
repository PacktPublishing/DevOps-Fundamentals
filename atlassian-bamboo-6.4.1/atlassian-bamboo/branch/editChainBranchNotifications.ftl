[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.branch.EditChainBranchNotifications" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.branch.EditChainBranchNotifications" --]

<html>
<head>
    [#if fn.isConfigurationReadOnly(immutablePlan)]
        [@ui.header pageKey="branch.configuration.view.title.long" object=immutablePlan.name title=true /]
    [#else]
        [@ui.header pageKey="branch.configuration.edit.title.long" object=immutablePlan.name title=true /]
    [/#if]
    <meta name="tab" content="branch.notifications"/>
</head>
<body>

[#import "/lib/menus.ftl" as menu]

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
    [@ui.header pageKey="branch.notifications" headerElement="h2" /]
[#else]
    [@ui.header pageKey="branch.notifications" descriptionKey="branch.notifications.description" headerElement="h2" /]
[/#if]

[#assign pageContent]
    [@ww.form action="saveChainBranchNotifications" namespace="/branch/admin/config" cancelUri='/browse/${immutableChain.key}/config' submitLabelKey='global.buttons.update']
        [@ww.hidden name="returnUrl" /]
        [@ww.hidden name="planKey" /]
        [@ww.hidden name="buildKey" /]

        [@ww.radio name="branchConfiguration.notificationStrategy"
            listKey="key"
            listValue="key"
            i18nPrefixForValue="branch.notifications"
            showDescription=true
            list=notificationStrategies /]
    [/@ww.form]
[/#assign]

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
    [@menu.displayTabbedContent location="branchConfiguration.subMenu" selectedTab="branch.notifications" linkCssClass="jsLoadPage" historyXhrDisabled=true]
        ${pageContent}
    [/@menu.displayTabbedContent]
[#else]
    ${pageContent}
[/#if]


</body>
</html>
