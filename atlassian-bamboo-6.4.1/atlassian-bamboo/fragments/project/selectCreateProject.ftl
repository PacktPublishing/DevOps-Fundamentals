[#-- @ftlvariable name="uiConfigBean" type="com.atlassian.bamboo.ww2.actions.build.admin.create.UIConfigSupport" --]

[#--
    Requirements:
    existingProjectKey  scalar which will hold existing project's key 
    projectKey          scalar which will hold new project key
    projectName         scalar which will hold new project name
--]
[#assign canCreateProject = ctx.canCreateProject() /]
[#assign canUseExistingProject = uiConfigBean.existingProjectsForPlanCreation?has_content /]

[#if canUseExistingProject && canCreateProject]
    [@s.select labelKey='project' name='existingProjectKey' toggle='true'
        list='uiConfigBean.existingProjectsForPlanCreation' listKey='key' listValue='name' groupLabel='Existing Projects'
        headerKey='newProject' headerValue='New Project' ]
    [/@s.select]

    <script>
        require('widget/simple-select2')('[name="existingProjectKey"]');
    </script>

    [@ui.bambooSection dependsOn='existingProjectKey' showOn='newProject']
        [@s.textfield labelKey='project.name' name='projectName' id='projectName' required=true /]
        [@s.textfield labelKey='project.key' name='projectKey' fromField='projectName' template='keyGenerator' /]
        [@s.textfield labelKey='projectDescription' name='projectDescription' required=false longField=true /]
    [/@ui.bambooSection]
[#elseif canUseExistingProject]
    [@s.select labelKey='project' name='existingProjectKey' toggle='true'
        list='uiConfigBean.existingProjectsForPlanCreation' listKey='key' listValue='name']
    [/@s.select]

    <script>
        require('widget/simple-select2')('[name="existingProjectKey"]');
    </script>
[#elseif canCreateProject]
    [@s.textfield labelKey='project.name' name='projectName' id='projectName' required=true /]
    [@s.textfield labelKey='project.key' name='projectKey' fromField='projectName' template='keyGenerator' /]
    [@s.textfield labelKey='projectDescription' name='projectDescription' required=false longField=true /]
[#else]
    [@ui.messageBox type='warning']
        [@s.text name='plan.create.error.no.available.projects' /][#nt]
        [@s.text name='plan.create.error.insufficient.permissions.create.project' /][#nt]
    [/@ui.messageBox]
[/#if]
