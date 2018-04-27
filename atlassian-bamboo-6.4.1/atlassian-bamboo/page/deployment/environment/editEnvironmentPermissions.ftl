[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.ConfigureEnvironmentPermissions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.ConfigureEnvironmentPermissions" --]
[#import "/fragments/permissions/permissions.ftl" as permissions/]
[@ww.text var="title" name="environment.edit.permissions.title"]
    [@ww.param][#if environment??]${environment.name?html}[#else]Unknown[/#if][/@ww.param]
[/@ww.text]
<html>
<head>
[@ui.header pageKey=title title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>
<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.environment.permissions.howtheywork"][@ww.text name="deployments.environment.permissions.howtheywork.title"/][/@help.url]</div>
[@ui.header pageKey=title descriptionKey="environment.edit.permissions.description" headerElement="h2"/]

[#if environment?has_content]

<div class="deploymentPermissionsContainer"></div>
<form class="aui top-label">
    <div class="buttons-container">
        ${soy.render('aui.buttons.buttons', {
            'content': soy.render('aui.buttons.button', {
                'href': '${req.contextPath}/deploy/config/configureDeploymentProject.action?id=${deploymentProjectId}&environmentId=${environmentId}',
                'text': ' ' + i18n.getText('deployment.environment.configuration.back'),
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
            baseEndpoint: '${req.contextPath}/rest/api/latest/permissions/environment/${environmentId}',
            permissions: permissions,
            dependencies: dependencies,
            analyticsEntityType: 'ENVIRONMENT'
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
