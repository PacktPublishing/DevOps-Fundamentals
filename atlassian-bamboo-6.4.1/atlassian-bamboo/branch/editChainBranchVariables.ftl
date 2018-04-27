[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.variable.ConfigurePlanVariables" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.variable.ConfigurePlanVariables" --]
[#import "/fragments/variable/variables.ftl" as variables/]

<html>
<head>
    [#if fn.isConfigurationReadOnly(immutablePlan)]
        [@ui.header pageKey="branch.configuration.view.title.long" object=immutablePlan.name title=true /]
    [#else]
        [@ui.header pageKey="branch.configuration.edit.title.long" object=immutablePlan.name title=true /]
    [/#if]
    <meta name="tab" content="branch.variables"/>
</head>
<body>

[#import "/lib/menus.ftl" as menu]

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
    [@ui.header pageKey="branch.config.variables.heading" headerElement="h2"/]
[#else]
    [@ui.header pageKey="branch.config.variables.heading" descriptionKey="branch.config.variables.description" headerElement="h2"/]
[/#if]

[#assign pageContent]
    [@ww.url var="createVariableUrl" namespace="/build/admin/ajax" action="createPlanVariable" planKey=immutablePlan.key /]
    [@ww.url var="deleteVariableUrl" namespace="/build/admin/ajax" action="deletePlanVariable" planKey=immutablePlan.key variableId="VARIABLE_ID"/]
    [@ww.url var="updateVariableUrl" namespace="/build/admin/ajax" action="updatePlanVariable" planKey=immutablePlan.key/]

    [@variables.configureVariables
        id="planVariables"
        variablesList=action.variables
        createVariableUrl=createVariableUrl
        deleteVariableUrl=deleteVariableUrl
        updateVariableUrl=updateVariableUrl
        availableVariables=inheritedVariables
        overriddenVariablesMap=overriddenVariablesMap
        tableId="branch-variable-config"/]
[/#assign]

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
    [@menu.displayTabbedContent location="branchConfiguration.subMenu" selectedTab="branch.variables" linkCssClass="jsLoadPage" historyXhrDisabled=true]
        ${pageContent}
    [/@menu.displayTabbedContent]
[#else]
    ${pageContent}
[/#if]

</body>
</html>