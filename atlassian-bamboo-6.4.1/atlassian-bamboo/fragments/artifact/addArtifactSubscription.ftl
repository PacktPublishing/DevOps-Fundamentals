[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureArtifactSubscription" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureArtifactSubscription" --]

[@s.form action="createArtifactSubscription" namespace="/ajax"
        cssClass="bambooAuiDialogForm"
        descriptionKey='artifact.subscription.create.description'
        submitLabelKey='global.buttons.create']

    [@s.select labelKey='artifact.subscription.name' name='artifactDefinitionId' list=availableArtifacts groupBy='producerJob.stage.name' listKey='id' listValue='name' headerKey='' headerValue='Select\x2026' required=true /]
    [@s.textfield labelKey='artifact.subscription.destination' name='destination' /]
    [@s.hidden name='planKey' /]
    [@s.hidden name='returnUrl' /]
[/@s.form]