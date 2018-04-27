[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildPermissions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildPermissions" --]
[#import "/lib/build.ftl" as bd]
[#import "editChainConfigurationCommon.ftl" as eccc/]

[#if immutablePlan?has_content]

[#assign readOnlyMode = fn.isConfigurationReadOnly(immutablePlan) /]
[#assign description]
    [@s.text name="build.permissions.description"/][#nt]
    [@help.url pageKey='permissions.howtheywork'][@s.text name='global.learn.more'/][/@help.url]
[/#assign]

[@eccc.editChainConfigurationPage plan=immutablePlan selectedTab='permissions' titleKey='build.permissions.title' description=description]
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

                [#if !readOnlyMode]
                    editablePermissions.push('${permissionEntry.value}');
                [/#if]
            [/#list]

            var permissionsPage = new PermissionsPage({
                el: '.permissionsContainer',
                baseEndpoint: '${req.contextPath}/rest/api/latest/permissions/plan/${immutablePlan.key}',
                permissions: permissions,
                editablePermissions: editablePermissions,
                dependencies: dependencies,
                analyticsEntityType: 'PLAN'
            });

            permissionsPage.render();
        })
    </script>
[/@eccc.editChainConfigurationPage]

[#else]
    [#-- Error state, display action errors --]
    [#list actionErrors as error]
        [@ui.messageBox type="error"]${error}[/@ui.messageBox]
    [/#list]
[/#if]
