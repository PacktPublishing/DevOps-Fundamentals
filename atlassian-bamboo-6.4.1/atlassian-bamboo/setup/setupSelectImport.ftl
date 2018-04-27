[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupImportDataAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupImportDataAction" --]
<html>
<head>
    <title>[@s.text name='setup.data.title' /]</title>
    <meta name="step" content="3">
</head>

<body>

[@ui.header pageKey='setup.data.title' headerElement='h2' /]

[@s.form action="performImportData" submitLabelKey='global.buttons.continue']

    [@s.radio key='setup.data.options' name='dataOption' listKey='key' listValue='value' toggle=true list=importOptions /]

    [@ui.bambooSection dependsOn='dataOption' showOn='import']
        [@s.textfield key='setup.data.import.path' name='importPath' required=true cssClass="long-field" /]
    [/@ui.bambooSection]

[/@s.form ]

</body>
</html>