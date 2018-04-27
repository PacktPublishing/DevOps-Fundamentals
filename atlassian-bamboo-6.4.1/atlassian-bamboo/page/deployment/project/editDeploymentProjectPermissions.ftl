[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.projects.actions.ConfigureDeploymentProjectPermissions" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.projects.actions.ConfigureDeploymentProjectPermissions" --]

[#import "/fragments/permissions/permissions.ftl" as permissions/]

[@s.text var="title" name="deployment.project.edit.permissions.title"]
    [@s.param][#if deploymentProject??]${deploymentProject.name?html}[#else]Unknown[/#if][/@s.param]
[/@s.text]
<html>
<head>
[@ui.header page=headerText title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>
<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.project.permissions.howtheywork"][@ww.text name="deployments.project.permissions.howtheywork.title"/][/@help.url]</div>
[@ui.header page=title descriptionKey="deployment.project.edit.permissions.description" headerElement="h2"/]

[#if deploymentProject?has_content]

<div class="deploymentPermissionsContainer"></div>
<form class="aui top-label">
    <div class="buttons-container">
        ${soy.render('aui.buttons.buttons', {
            'content': soy.render('aui.buttons.button', {
                'href': '${req.contextPath}/deploy/config/configureDeploymentProject.action?id=${deploymentProjectId}',
                'text': ' ' + i18n.getText('deployment.project.configuration.back'),
                'iconClass': 'aui-icon-small aui-iconfont-back-page',
                'iconType': 'aui'
            })
        })}
    </div>
</form>

<script>
    require(['page/permissions'], function(PermissionsPage) {

        var permissions = [];
        var dependencies = {};

        [#list editablePermissions.entrySet() as permissionEntry]
            [#assign permissionName = permissionEntry.value /]
            [#assign permissionLabelKey = permissionEntry.key /]

            permissions.push({ name: '${permissionName}', label: '${i18n.getText(permissionLabelKey)}' });

            dependencies['${permissionName}'] = [];
            [#list action.getPermissionDependencies(permissionName) as dependentPermission]
                dependencies['${permissionName}'].push('${dependentPermission}');
            [/#list]
        [/#list]

        var permissionsPage = new PermissionsPage({
            el: '.deploymentPermissionsContainer',
            baseEndpoint: '${req.contextPath}/rest/api/latest/permissions/deployment/${deploymentProjectId}',
            permissions: permissions,
            dependencies: dependencies,
            analyticsEntityType: 'DEPLOYMENT_PROJECT'
        });

        permissionsPage.render();
    })
</script>

[#else]
    [#-- Error state, display action errors --]
    [#list actionErrors as error]
        [@ui.messageBox type="error"]${error}[/@ui.messageBox]
    [/#list]
[/#if]

</body>
</html>
