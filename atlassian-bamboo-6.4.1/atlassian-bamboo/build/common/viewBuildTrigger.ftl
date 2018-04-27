[#-- @ftlvariable name="uiConfigBean" type="com.atlassian.bamboo.ww2.actions.build.admin.create.UIConfigSupportImpl" --]

[#macro viewBuildTrigger bulk=false]
    [#assign buildStrategyType = stack.findValue('selectedBuildStrategy').toString() /]
    [#assign selectedTrigger = action.getSelectedTrigger(buildStrategyType)/]
    [#if selectedTrigger?has_content]
        [@s.label key='repository.change' value=selectedTrigger.name /]
        <div class="field-group description"><p>${selectedTrigger.description!?html}</p></div>

        [#if bulk]
            [#assign allRepositoriesWarning]
                [@s.text name="repository.config.allRepositories" /]
            [/#assign]
            [@ui.bambooSection dependsOn='selectedBuildStrategy' showOn=keysOfTriggersExpectingRepository]
                [@s.label key='repository.config.repositoryTrigger' value=allRepositoriesWarning/]
            [/@ui.bambooSection]
        [/#if]

        ${selectedTrigger.html!}
    [#else]
        [#--error here--]
    [/#if]

[/#macro]
