[@s.form action=submitAction
method='POST'
enctype='multipart/form-data'
namespace="/deploy/config"
submitLabelKey="chain.trigger.update.button"
cancelUri="/deploy/config/configureEnvironmentTriggers.action?environmentId=${environmentId}"
titleKey="chain.trigger.title"
cssClass="top-label"]

    [@s.hidden name="environmentId" value=environmentId /]
    [@s.hidden name="triggerId" value=triggerId /]
    [@s.hidden name="createTriggerKey" value=createTriggerKey/]

    [@s.textfield labelKey="chain.trigger.description" name="userDescription" id="userDescription"/]
    [@ww.checkbox name="triggerDisabled" labelKey="triggers.disable" fieldClass="disable-checkbox" /]

    ${editHtml!}

[/@s.form]