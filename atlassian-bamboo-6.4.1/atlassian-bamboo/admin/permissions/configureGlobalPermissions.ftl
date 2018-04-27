[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ConfigureGlobalPermissions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ConfigureGlobalPermissions" --]

[#import "/fragments/permissions/permissions.ftl" as permissions/]

<html>
<head>
    <title>[@ww.text name='config.global.permissions.title' /]</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="configureGlobalPermissions">
</head>
<body>
[@ui.header pageKey='config.global.permissions.heading' descriptionKey='config.global.permissions.description' /]

<div class="permissionsContainer"></div>
<script>
    require(['page/permissions'], function(PermissionsPage) {

        var permissions = [];
        var editablePermissions = [];
        var dependencies = {};

        [#list supportedPermissions.entrySet() as permissionEntry]
            [#assign permissionName = permissionEntry.value /]
            [#assign permissionLabelKey = permissionEntry.key /]

            permissions.push({ name: '${permissionName}', label: '${i18n.getText(permissionLabelKey)}' });

            dependencies['${permissionName}'] = [];
            [#list action.getPermissionDependencies(permissionName) as dependentPermission]
                dependencies['${permissionName}'].push('${dependentPermission}');
            [/#list]
        [/#list]

        [#list editablePermissions as editablePermission]
            editablePermissions.push('${editablePermission}');
        [/#list]

        var permissionsPage = new PermissionsPage({
            el: '.permissionsContainer',
            baseEndpoint: '${req.contextPath}/rest/api/latest/permissions/global',
            permissions: permissions,
            editablePermissions: editablePermissions,
            dependencies: dependencies,
            analyticsEntityType: 'GLOBAL'
        });

        permissionsPage.render();
    })
</script>
</body>
</html>
