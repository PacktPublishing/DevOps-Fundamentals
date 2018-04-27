[#-- @ftlvariable name="triggerUiConfigBean" type="com.atlassian.bamboo.ww2.actions.chains.admin.triggers.TriggerUIConfigBean" --]

[#macro configureTrigger bulk=false deployment=false]
    [#assign planBranchLozengeLabel][@s.text  name='deployment.trigger.planBranch'/][/#assign]

    [#assign descriptionKey='repository.change.description'/]
    [#if deployment]
        [#assign descriptionKey='deployment.triggerType.description'/]
    [/#if]

    [#assign showRepositorySelectorOn = ""/]
    [#if !deployment]
        [#assign showRepositorySelectorOn = keysOfTriggersExpectingRepository /]
    [/#if]

    [@s.select labelKey='repository.change' descriptionKey=descriptionKey
        name='selectedBuildStrategy' id='selectedBuildStrategy'
        listKey='key' listValue='name' optionDescription='description' toggle='true'
        list=triggerSelectors required=true
        cssClass='long-field'/]

    [#if bulk]
        [#assign allRepositoriesWarning]
            [@s.text name="repository.config.allRepositories" /]
        [/#assign]
        [@ui.bambooSection dependsOn='selectedBuildStrategy' showOn=showRepositorySelectorOn]
            [@s.label key='repository.config.repositoryTrigger' value=allRepositoriesWarning cssClass="all-repositories"/]
        [/@ui.bambooSection]
    [/#if]

    [#if !bulk && !deployment]
        [@s.checkboxlist labelKey="repository.config.repositoryTrigger"
            name="repositoryTrigger"
            id="repositoryTriggers"
            list=repositoryTriggerSelectors
            listKey="id"
            listValue="name"
            listChecked="buildTrigger"
            dependsOn="selectedBuildStrategy" showOn=showRepositorySelectorOn/]
    [/#if]

    [#list triggerSelectors as triggerSelector]
        [@ui.bambooSection dependsOn='selectedBuildStrategy' showOn=triggerSelector.key]
            ${triggerSelector.html!}
        [/@ui.bambooSection]
    [/#list]

    [#if !bulk && !deployment]
        [#assign conditionHtml = triggerConditionEditHtml /]
        [#if conditionHtml?has_content]
            [@ui.bambooSection titleKey='repository.change.conditions']
                ${conditionHtml}
            [/@ui.bambooSection]
        [/#if]
    [/#if]
[/#macro]

