[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildRequirement" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildRequirement" --]

[#import "/lib/build.ftl" as bd]
[#import "/lib/menus.ftl" as menu]
[#import "editBuildConfigurationCommon.ftl" as ebcc/]

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
    <h2>${navigationContext.currentObject.displayName}</h2>
    [@menu.displayJobsTabs
        currentPlan=navigationContext.currentObject
        selectedTab="requirements"
    /]
[/#if]

[@ebcc.editConfigurationPage plan=immutablePlan  selectedTab='requirements' titleKey='requirement.title']
    [@bd.configureBuildRequirement requirementSetDecorator=requirementSetDecorator plan=immutablePlan elasticBambooEnabled=elasticBambooEnabled/]
[/@ebcc.editConfigurationPage]