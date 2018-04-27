[@ww.form action=submitAction
    method='POST'
    enctype='multipart/form-data'
    namespace="/chain/admin/config"
    submitLabelKey="chain.trigger.update.button"
    cancelUri="/chain/admin/config/editChainTriggers.action?planKey=${planKey}"
    titleKey="chain.trigger.title"
    cssClass="top-label"]

    [@ww.hidden name="planKey" value=planKey /]
    [@ww.hidden name="triggerId" value=triggerId /]
    [@ww.hidden name="createTriggerKey" value=createTriggerKey/]

    [@ww.textfield labelKey="chain.trigger.description" name="userDescription" id="userDescription"/]
    [@ww.checkbox name="triggerDisabled" labelKey="triggers.disable" fieldClass="disable-checkbox" /]

    [#if useStandardRepositorySelector]
        [@s.checkboxlist
        labelKey="repository.config.repositoryTrigger"
        name="repositoryTrigger"
        id="repositoryTriggers"
        list=repositoryTriggerSelectors
        listKey="id"
        listValue="name"
        listChecked="buildTrigger"
        /]
    [/#if]

    ${editHtml!}

    [#assign condtionHtml = triggerConditionEditHtml /]
    [#if condtionHtml?has_content]
        [@ui.bambooSection titleKey='repository.change.conditions']
            ${condtionHtml}
        [/@ui.bambooSection]
    [/#if]
[/@ww.form]