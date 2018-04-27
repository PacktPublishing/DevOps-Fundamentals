[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.project.EditProjectPermissions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.project.EditProjectPermissions" --]
[#import "/fragments/permissions/permissions.ftl" as permissions/]

<html>
<head>
    [@ui.header pageKey='project.configuration.project.permissions.page.title' object='${(project.name)!}' title=true /]
    <meta name="projectCrumb" content="project.permissions">
</head>
<body>
    [#assign pageDescription]
        [@s.text name='project.configuration.project.permissions.page.description'/][#nt]
        [@help.url pageKey='permissions.howtheywork'][@s.text name='global.learn.more'/][/@help.url]
    [/#assign]
    [@ui.header pageKey='project.configuration.project.permissions.page.title' description=pageDescription /]

    <div class="permissionsContainer"></div>
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
                el: '.permissionsContainer',
                baseEndpoint: '${req.contextPath}/rest/api/latest/permissions/project/${projectKey}',
                permissions: permissions,
                dependencies: dependencies,
                analyticsEntityType: 'PROJECT'
            });

            permissionsPage.render();
        })
    </script>
<script>
    AJS.trigger('analytics',
            {
                name: 'bamboo.page.visited.project.editProjectPermissions',
            }
    );
</script>
</body>
</html>
