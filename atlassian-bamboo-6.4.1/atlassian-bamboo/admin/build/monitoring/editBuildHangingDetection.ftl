[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.monitoring.ConfigureGlobalBuildHangingDetection" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.monitoring.ConfigureGlobalBuildHangingDetection" --]
<html>
<head>
	<title>[@ww.text name='buildMonitoring.title' /]</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="buildMonitoring">
</head>
<body>
    [@s.form
        action='saveBuildHangingDetection'
        namespace='/admin'
        cancelUri='/admin/buildHangingDetection.action'
        submitLabelKey='global.buttons.update'
        titleKey='buildMonitoring.title'
        descriptionKey='buildMonitoring.description'
        cssClass='left-aligned'
    ]
        [@ui.bambooSection cssClass='left-aligned__section' ]
            [@s.checkbox
                id='enableBuildMonitoring'
                name='enableBuildMonitoring'
                labelKey='buildMonitoring.hanging.enable'
                toggle=true
            /]
        [/@ui.bambooSection ]
        [@ui.bambooSection titleKey='buildMonitoring.hanging.form'
            descriptionKey='buildMonitoring.hanging.form.description'
            dependsOn='enableBuildMonitoring' ]
            [@s.textfield name='multiplier' labelKey='buildMonitoring.hanging.multiplier' /]
            [@s.textfield name='minutesBetweenLogs' labelKey='buildMonitoring.hanging.logtime' /]
            [@s.textfield name='minutesBeforeQueueTimeout' labelKey='buildMonitoring.hanging.queuetimeout' /]
        [/@ui.bambooSection]
        [@ui.bambooSection cssClass='left-aligned__section' dependsOn='enableBuildMonitoring']
            [@s.checkbox id='enableForceStop' name='enableForceStop' labelKey='buildMonitoring.force.stop.enable' /]
        [/@ui.bambooSection ]
    [/@s.form ]
[#if action.configurationUpdated]
    [#assign configurationUpdatedMessage]
        [@s.text name='buildMonitoring.update.successful' /]
    [/#assign]
    <script>
        require(['aui/flag'], function(Flag) {
            new Flag({
                type: 'success',
                close: 'auto',
                body: '${configurationUpdatedMessage?js_string}'
            });
        });
    </script>
[/#if]
</body>
</html>
