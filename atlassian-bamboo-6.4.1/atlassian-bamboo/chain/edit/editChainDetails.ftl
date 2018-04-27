[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.EditChainDetails" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.EditChainDetails" --]
[#import "editChainConfigurationCommon.ftl" as eccc/]

[@eccc.editChainConfigurationPage descriptionKey="chain.details.edit.description" plan=immutablePlan selectedTab='build.details' titleKey="chain.details.edit"]

    [@s.form action="saveChainDetails" namespace="/chain/admin/config" cancelUri='/browse/${immutableChain.key}/config' submitLabelKey='global.buttons.update']
        [@s.hidden name="buildKey" /]
        [@s.textfield labelKey='project.name' name='projectName' required=true /]
        [@s.textfield labelKey='projectDescription' name='projectDescription' required=false longField=true /]
        [@s.textfield labelKey='chain.name' name='chainName' required=true /]
        [@s.textfield labelKey='chainDescription' name='chainDescription' required=false longField=true /]
        [@s.checkbox labelKey='plan.enabled' name="enabled" /]
        [@s.hidden name="returnUrl" /]
        [@s.hidden name="planKey" /]
    [/@s.form]

[/@eccc.editChainConfigurationPage]
