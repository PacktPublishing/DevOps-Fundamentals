[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.MoveBuilds" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.MoveBuilds" --]
<html>
<head>
    <title>[@s.text name='build.move.title' /]</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="moveBuilds">
</head>
<body>

[#if !buildQueuesDisabled]
    [@s.text name='build.move.warning' var="buildMoveWarning"]
        [@s.param]<a class="mutative" href="[@s.url action='disableAllAgents' namespace='/admin/agent' returnUrl='${currentUrl}'/]">[/@s.param]
        [@s.param]</a>[/@s.param]
    [/@s.text]
    [@ui.messageBox type="warning" title=buildMoveWarning /]
[/#if]

[#if sortedProjects?has_content]
    [@s.form action="selectBuildsToMove" namespace="/admin"
              submitLabelKey='global.buttons.move'
              titleKey='build.move.form.title'
              descriptionKey='build.move.description']

        [@s.select labelKey='build.move.destination.project' name='existingProjectKey' toggle='true'
                    list='sortedProjects' listKey='key' listValue='name'
                    headerKey='newProject' headerValue='New Project' groupLabel="Projects" ]
        [/@s.select]

        <script>
            require('widget/simple-select2')('[name="existingProjectKey"]');
        </script>

        [@ui.bambooSection dependsOn='existingProjectKey' showOn='newProject']
            [@s.textfield labelKey='project.name' name='projectName' required=true /]
            [@s.textfield labelKey='project.key' name='projectKey' required=true /]
            [@s.textfield labelKey='projectDescription' name='projectDescription' required=false longField=true /]
        [/@ui.bambooSection]

        [@cp.displayBulkActionSelector bulkAction=action checkboxFieldValueType='id' planCheckboxName='planIds' /]
    [/@s.form]
[#else]
    [@s.text name='build.move.plans.none' /]
[/#if]
