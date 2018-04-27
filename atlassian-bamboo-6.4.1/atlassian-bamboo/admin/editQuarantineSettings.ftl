[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.QuarantineSettingsAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.QuarantineSettingsAction" --]

<html>
<head>
    <title>[@s.text name='admin.quarantineSettings.title' /]</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="quarantineSettings">
</head>
<body>
<h1>[@s.text name='admin.quarantineSettings.title' /]</h1>

<p>
    [@s.text name='admin.quarantineSettings.description'/]
</p>

[@s.form id='quarantineSettingsForm' action='saveQuarantineSettings' submitLabelKey='global.buttons.update']
    [@s.checkbox name='enabled' labelKey='admin.quarantineSettings.enabled' toggle='true' /]
    [#if featureManager.limitedTimeQuarantineEnabled]
        [@ui.bambooSection dependsOn='enabled' showOn='true' titleKey='admin.quarantineSettings.advanced']
            [#assign periodValue]${stack.findString('expiryPeriod')!'days'}[/#assign]
            [@s.textfield name='expiryDuration' labelKey='admin.quarantineSettings.expiryDuration'
                          template='periodPicker' periodField='expiryPeriod' periodValue=periodValue
                          required=true /]
            [@s.checkbox name='expiryOverridable' labelKey='admin.quarantineSettings.expiryOverridable' /]
            [@ui.bambooSection titleKey="admin.quarantineSettings.resumeSchedule"]
                [@s.text name="admin.quarantineSettings.resumeSchedule.details" /]
                [@dj.cronBuilder name='cronExpression' /]
            [/@ui.bambooSection]
        [/@ui.bambooSection]
    [/#if]
[/@s.form]

</body>
</html>