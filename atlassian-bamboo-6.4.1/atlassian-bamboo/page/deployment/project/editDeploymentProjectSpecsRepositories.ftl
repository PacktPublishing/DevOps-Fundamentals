[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.projects.actions.ConfigureDeploymentProjectSpecsRepositories" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.projects.actions.ConfigureDeploymentProjectSpecsRepositories" --]

[#assign pageTitle]
    [@s.text name='deployment.project.edit.specs.repositories.title']
        [@s.param][#if deploymentProject??]${deploymentProject.name?html}[#else]Unknown[/#if][/@s.param]
    [/@s.text]
[/#assign]
[#assign pageDescription]
    [@s.text name='deployment.project.edit.specs.repositories.description']
        [@s.param][@help.href pageKey='security.rss' /][/@s.param]
    [/@s.text]
[/#assign]

<html>
<head>
    [@ui.header page=pageTitle title=true /]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
    ${webResourceManager.requireResource('bamboo.web.resources.common:feature-specs-repositories-selection')}
</head>
<body>
    [@ui.header page=pageTitle description=pageDescription headerElement='h2' /]
    [@ww.form cssClass='top-label']
        <div class="specs-repositories-selection-container" style="margin-bottom: 50px"></div>
        <script>
            require('feature/specs-repositories-selection')({
                el: '.specs-repositories-selection-container',
                endpoints: {
                    add: '${req.contextPath}/rest/api/latest/deploy/project/${action.deploymentProjectId}/repository', //POST
                    search: '${req.contextPath}/rest/api/latest/deploy/project/${action.deploymentProjectId}/repository/search', //GET
                    list: '${req.contextPath}/rest/api/latest/deploy/project/${action.deploymentProjectId}/repository', //GET
                    [#--delete: '${req.contextPath}/rest/api/latest/deploy/project/${action.deploymentProjectId}/repository/{repositoryId}' not required, just added for visibility--]
                }
            });
        </script>

        <div class="buttons-container">
            ${soy.render('aui.buttons.buttons', {
                'content': soy.render('aui.buttons.button', {
                    'href': '${req.contextPath}/deploy/config/configureDeploymentProject.action?id=${deploymentProjectId}',
                    'text': ' ' + i18n.getText('deployment.project.edit.specs.repositories.back.text'),
                    'iconClass': 'aui-icon-small aui-iconfont-back-page',
                    'iconType': 'aui'
                })
            })}
        </div>

        [@ww.hidden name='deploymentProjectId' /]
    [/@ww.form]
</body>
</html>
