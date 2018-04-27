[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.project.EditProjectRepositories" --]
<html>
<head>
    [@ui.header pageKey='project.configuration.specs.repositories' object='${(project.name)!}' title=true /]
    <meta name="projectCrumb" content="project.repositories">
    ${webResourceManager.requireResource('bamboo.web.resources.common:feature-specs-repositories-selection')}
</head>

<body>
    [@ww.form titleKey='project.configuration.specs.repositories']
        <p class="description">
            [@s.text name='project.configuration.specs.repositories.description']
                [@s.param][@help.href pageKey='security.rss' /][/@s.param]
            [/@s.text]
        </p>

        <div class="specs-repositories-selection-container"></div>
        <script>
            require('feature/specs-repositories-selection')({
                el: '.specs-repositories-selection-container',
                endpoints: {
                    add: '${req.contextPath}/rest/api/latest/project/${action.projectKey}/repository', //POST
                    search: '${req.contextPath}/rest/api/latest/project/${action.projectKey}/repository/search', //GET
                    list: '${req.contextPath}/rest/api/latest/project/${action.projectKey}/repository', //GET + DELETE
                    [#--delete: '${req.contextPath}/rest/api/latest/project/${action.projectKey}/repository/{repositoryId}' not required, just added for visibility--]
                }
            });
        </script>
    [/@ww.form]
<script>
    AJS.trigger('analytics',
            {
                name: 'bamboo.page.visited.project.editProjectSpecsRepositories',
            }
    );
</script>
</body>
</html>
