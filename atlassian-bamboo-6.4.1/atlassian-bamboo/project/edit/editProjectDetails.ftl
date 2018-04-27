[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.project.EditProjectDetails" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.project.EditProjectDetails" --]

<html>
<head>
    [@ui.header pageKey='project.configuration.details.page.title' object='${(project.name)!}' title=true /]
    <meta name="projectCrumb" content="project.details">
</head>

<body>
    [#assign pageDescription]
        [@s.text name='project.configuration.details.page.description'/][#nt]
        [@help.url pageKey='projects.howtheywork'][@s.text name='global.learn.more'/][/@help.url]
    [/#assign]
    [@ui.header pageKey='project.configuration.details.page.title' description=pageDescription /]

    [@s.form action='saveProjectDetails' namespace='/project/admin/config' cancelUri='/browse/${projectKey}' submitLabelKey='global.buttons.update']
        [@s.textfield labelKey='project.configuration.details.name' name='projectName' required=true /]
        [@s.label labelKey='project.configuration.details.key' value=projectKey /]
        [@s.textfield labelKey='project.configuration.details.description' name='projectDescription' longField=true /]
        [@s.hidden name='projectKey' /]
    [/@s.form]
<script>
    AJS.trigger('analytics',
            {
                name: 'bamboo.page.visited.project.editProject',
            }
    );
</script>
</body>
</html>
