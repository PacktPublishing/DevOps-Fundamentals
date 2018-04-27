[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.project.ListProjects" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.project.ListProjects --]

<html>
<head>
    <title>[@s.text name='dashboard.projects.page.title' /]</title>
    <meta name="decorator" content="projectList" />
</head>
<body>
    [#assign projectsCount = action.countProjects() /]
    [#if projectsCount > 0]
        <div id="projectsTable"></div>
        <script>
            require('page/projects', function(ProjectsApplication) {
                new ProjectsApplication({
                    region: '#projectsTable',
                    totalRecords: ${projectsCount}
                }).start();
            })
        </script>
    [#else]
        [#-- empty state --]
        [#assign imageUrl = req.contextPath + '/images/project-empty.svg' /]

        [#if !(user?has_content)]
            [#-- empty state with links to log in or sign up --]
            [@ui.emptyState
                    headerKey='dashboard.projects.empty.state.active.header'
                    descriptionKey='dashboard.projects.empty.state.active.description'
                    imageUrl=imageUrl]
                [@s.url var="loginUrl" value="/userlogin!doDefault.action?os_destination=${ctx.getCurrentUrl(req)?url}" /]
                [@s.url var="signupUrl" value="/signupUser!doDefault.action" /]
                <a href="${loginUrl}" class="aui-button aui-button-primary">[@s.text name='bamboo.banner.login' /]</a>[#t]
                <a href="${signupUrl}" class="aui-button">[@s.text name='bamboo.banner.signup' /]</a>[#t]
            [/@ui.emptyState]

        [#elseif ctx.canCreateProject()]
            [#-- empty state with link to create project --]
            [@ui.emptyState headerKey='dashboard.projects.empty.state.active.header'
                    descriptionKey='dashboard.projects.empty.state.active.description'
                    imageUrl=imageUrl]
                [@s.url var="createUrl" value="/project/newProject.action" /]
                <a href="${createUrl}" class="aui-button aui-button-primary">
                    [@s.text name='dashboard.projects.empty.state.active.action.label' /]
                </a>
            [/@ui.emptyState]

        [#else]
            [#-- passive empty state, no action links --]
            [#assign description]
                [@s.text name="dashboard.projects.empty.state.passive.description"]
                    [@s.param][@s.text name='permissions.howtheywork'/][/@s.param]
                [/@s.text]
            [/#assign]
            [@ui.emptyState headerKey='dashboard.projects.empty.state.passive.header'
                    description=description
                    imageUrl=imageUrl /]
        [/#if]
    [/#if]
<script>
    AJS.trigger('analytics',
            {
                name: 'bamboo.page.visited.project.allProjects',
            }
    );
</script>
</body>
</html>
