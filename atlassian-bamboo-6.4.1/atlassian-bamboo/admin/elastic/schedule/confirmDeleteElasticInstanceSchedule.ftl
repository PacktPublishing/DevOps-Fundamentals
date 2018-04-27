[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.schedule.ConfigureElasticInstanceSchedule" --]
<html>
<head>
    [@ui.header pageKey="elastic.schedule.delete.title" title=true /]
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="viewElasticInstanceSchedules">
</head>

<body>
[#assign shutdownConfirmation]
    [@ui.messageBox type="warning" titleKey="elastic.schedule.delete.comfirm" /]
[/#assign]

    [@s.form
              action='deleteElasticInstanceSchedule'
              namespace='/admin/elastic/schedule'
              titleKey='elastic.schedule.delete.title'
              description=shutdownConfirmation
              submitLabelKey='global.buttons.delete'
              cancelUri='/admin/elastic/schedule/viewElasticInstanceSchedules.action' ]

        [@s.hidden name='elasticInstanceScheduleId' /]
        [@s.hidden name='confirmed' value="true" /]

    [/@s.form]
</body>
</html>