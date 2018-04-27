[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.schedule.ConfigureElasticInstanceSchedule" --]
[#if elasticInstanceScheduleId > 0]
    [#assign mode = "edit" /]
[#else]
    [#assign mode = "add" /]
[/#if]
<html>
<head>
    <title>[@s.text name='elastic.schedule.${mode}.title' /]</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="viewElasticInstanceSchedules">
</head>

<body>
    <h1>[@s.text name='elastic.schedule.${mode}.title' /]</h1>

    <p>[@s.text name='elastic.schedule.${mode}.description' /]</p>

    [@s.form
              action='saveElasticInstanceSchedule'
              namespace='/admin/elastic/schedule'
              titleKey='elastic.schedule.${mode}.details'
              submitLabelKey='global.buttons.update'
              cancelUri='/admin/elastic/schedule/viewElasticInstanceSchedules.action' ]

        [#if mode == "edit"]
            [@s.hidden name='elasticInstanceScheduleId' /]
        [/#if]

        [@s.checkbox name='enabled' labelKey="global.buttons.enabled" /]

        [@s.radio name='whenOption'
            labelKey='elastic.schedule.whenOption'
            list=whenOptions
            listKey='name()'
            i18nPrefixForValue='elastic.schedule.whenOption'
            toggle=true /]

        [@ui.bambooSection dependsOn='whenOption' showOn='CRON']
            [@dj.cronBuilder "cronExpression"/]
        [/@ui.bambooSection]

        [@s.radio name='whatOption'
            labelKey='elastic.schedule.whatOption'
            list=whatOptions
            listKey='name()'
            i18nPrefixForValue='elastic.schedule.whatOption'
            toggle=true /]

        [@ui.bambooSection dependsOn='whatOption' showOn='ADJUST']
            
            [@s.select name='elasticImageConfigurationId' labelKey='elastic.schedule.elasticImageConfig' list=elasticImageConfigurations
                        listKey='id' listValue='configurationName'
                        optionDescription="configurationDescription" /]

            [#assign numInstances]
                [@s.textfield name='targetActiveInstances' required=true theme='inline' cssClass='text short-field' /]
            [/#assign]

            [@s.select name='activeInstanceAdjustmentType'
                        labelKey='elastic.schedule.targetActiveInstances'
                        list=activeInstanceAdjustmentTypes
                        listKey='name()'
                        i18nPrefixForValue='elastic.schedule.adjust.type'
                        extraUtility=numInstances
            /]
        [/@ui.bambooSection]

    [/@s.form]
</body>
</html>
