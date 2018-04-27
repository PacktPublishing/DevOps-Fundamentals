[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateProject" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateProject" --]

<html>
<head>
    <title>[@s.text name='project.create.new.title' /]</title>
    <meta name="decorator" content="focusTask"/>
</head>
<body>

[@ui.header pageKey="project.create.new.title" descriptionKey="project.create.new.description" headerElement="h2"/]

[@s.form
    action="saveNewProject"
    namespace="/project"
    method="post" enctype="multipart/form-data"
    cancelUri="start.action" submitLabelKey="global.buttons.update"
]
    <div class="configSection">
    [@s.textfield labelKey='project.name' name='projectName' id='projectName' required=true /]
    [@s.textfield labelKey='project.key' name='projectKey' fromField='projectName' template='keyGenerator' /]
    [@s.textfield longField=true labelKey='projectDescription' name='projectDescription' /]
    </div>
[/@s.form]

</body>
</html>
