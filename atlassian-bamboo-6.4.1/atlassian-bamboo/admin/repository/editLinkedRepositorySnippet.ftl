[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.repository.EditLinkedRepository" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.repository.EditLinkedRepository" --]

[#import "/lib/menus.ftl" as menu/]
[#import "/build/common/repositoryCommon.ftl" as rc/]

[#assign isEditMode = repositoryId > 0 /]

<html>
<head>
    [#if isEditMode]
        [@ui.header pageKey="sharedRepositories.edit.title" title=true/]
    [#else]
        [@ui.header pageKey="sharedRepositories.create.title" title=true/]
    [/#if]
    <meta name="decorator" content="focusTask">
    ${webResourceManager.requireResource('bamboo.web.resources.common:feature-specs-repositories-selection')}
</head>
<body>

<h2>
    [#if isEditMode]
        [@s.text name="repository.shared.edit.title" /]
    [#else]
        [@s.text name="vcs.create.new.title" /]
    [/#if]
</h2>

[#assign generalTabContents]
[#assign cancelUri][#if repositoryDashboardOn]/vcs/viewAllRepositories.action[#else]/admin/editLinkedRepository.action[/#if][/#assign]

[@s.form  action=submitAction
    method='POST'
    enctype='multipart/form-data'
    namespace="/admin"
    submitLabelKey="repository.update.button"
    cancelUri=cancelUri
]

    [@s.hidden name="repositoryId" value=repositoryId /]

    [#if successMessage?has_content]
        [@ui.messageBox type="success" title=successMessage?html /]
    [/#if]

    [#if currentVcsTypeSelector?has_content]
        [#assign repo=currentVcsTypeSelector/]
        [@s.hidden name="selectedRepository" id="selectedRepository" value=repo.key/]
        [@s.label labelKey="repository.type" value=repo.name /]
        [#if repo.optionDescription??]
            <div class="description">${repo.optionDescription}</div>
        [/#if]

        [@ui.bambooSection id='repository-id']
            [@s.textfield labelKey="repository.name" name="repositoryName" id="repositoryName" maxlength="${repositoryNameMaxLength}" required=true/]
        [/@ui.bambooSection]

        [@ui.bambooSection id='repository-configuration']
            ${repo.htmlFragments.locationHtml!}
            [@rc.branchEdit vcsTypeSelector=repo/]
            [#if repo.supportsConnectionTesting]
                [@rc.testRepositoryConnectionButton id="test-connection-" + repo.key?replace('[^a-zA-Z0-9]', '-', 'r') /]
            [/#if]
            [@rc.branchDetectionOptionsEdit vcsTypeSelector=repo/]
            [@rc.advancedRepositoryEdit vcsTypeSelector=repo /]
            [@rc.changeDetectionOptionsEdit vcsTypeSelector=repo /]
            [@rc.webRepositoryViewerEdit vcsTypeSelector=repo /]
        [/@ui.bambooSection]
    [/#if]
[/@s.form]
[/#assign]

[#if isEditMode && selectedRepository?has_content]
    [#assign permissionsTabContents]
        <div class="permissionsContainer"></div>
        <div class="permissions">
            <div class="permissions-title"><h3>[@s.text name='repository.shared.permissions.rss.heading' /]</h3></div>
            <div class="specs-repositories-selection-container"></div>
        </div>
        <script>
            require(['page/permissions', 'feature/specs-repositories-selection'],
                    function(PermissionsPage, RepositorySpecsPermissions) {
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
                            baseEndpoint: '${req.contextPath}/rest/api/latest/permissions/repository/${repositoryId}',
                            permissions: permissions,
                            dependencies: dependencies,
                            analyticsEntityType: 'REPOSITORY'
                        });

                        permissionsPage.render();

                        RepositorySpecsPermissions({
                            el: '.specs-repositories-selection-container',
                            targetType: 'repository',
                            endpoints: {
                                add: '${req.contextPath}/rest/api/latest/repository/${repositoryId}/rssrepository', //POST
                                search: '${req.contextPath}/rest/api/latest/repository/${repositoryId}/rssrepository/search', //GET
                                list: '${req.contextPath}/rest/api/latest/repository/${repositoryId}/rssrepository', //GET
                            [#--delete: '${req.contextPath}/rest/api/latest/repository/${repositoryId}/repository/{repositoryId}' not required, just added for visibility--]
                            }
                        });
                    })
        </script>
    [/#assign]

    [#assign usagesTabContents]
        [@rc.viewGlobalRepositoryUsages planUsingRepository hiddenPlansUsingRepositoryCount environmentUsingRepository hiddenEnvironmentsUsingRepositoryCount/]
    [/#assign]

    [#assign bambooSpecsTabContents]
    <div class="specs-configuration-container"></div>
    <script>
        require('feature/specs-configuration')({
            scan: ${action.bambooSpecsDetectionEnabled?c},
            allProjectsAccess: ${action.bambooSpecsPermittedToAllProjects?c},
            allProjectsEditable: ${action.bambooSpecsPermittedToAllProjectsEditable?c},
            allRepositoriesAccess: ${action.bambooSpecsPermittedToAllRepositories?c},
            allRepositoriesEditable: ${action.bambooSpecsPermittedToAllRepositoriesEditable?c},
            mailServerConfigured: ${action.mailServerConfigured?c},
            mailServerEditable: ${action.mailServerEditable?c},
            usages: {
                projects: [
                    [#list action.bambooSpecsPermittedProjects as project]
                        {
                            name: '${project.name?js_string}',
                            url: '${req.contextPath}/browse/${project.key}'
                        },
                    [/#list]
                ],
                deploymentProjects: [
                    [#list action.bambooSpecsPermittedDeploymentProjects as project]
                        {
                            name: '${project.name?js_string}',
                            url: '${req.contextPath}/deploy/viewDeploymentProjectEnvironments.action?id=${project.key.key?js_string}'
                        },
                    [/#list]
                ],
                repositories: [
                    [#list action.bambooSpecsPermittedRepositories as repository]
                        {
                            name: '${repository.name?js_string}',
                            url: '${req.contextPath}/admin/configureLinkedRepositories.action?repositoryId=${repository.id}'
                        },
                    [/#list]
                ]
            },
            endpoints: {
                enableCi: '${req.contextPath}/rest/api/latest/repository/${action.repositoryId}/enableCi',
                enableAllProjectsAccessUrl: '${req.contextPath}/rest/api/latest/repository/${action.repositoryId}/enableAllProjectsAccess',
                enableAllRepositoriesAccessUrl: '${req.contextPath}/rest/api/latest/repository/${action.repositoryId}/enableAllRepositoriesAccess',
            }
        }).$el.appendTo('.specs-configuration-container');
    </script>
    [/#assign]

    [#assign generalTab={
        'active': true,
        'id': 'linked-repos-general-tab',
        'label': action.getText('repository.tabs.general'),
        'contents': generalTabContents
    } /]

    [#assign permissionsTab={
        'id': 'linked-repos-permissions-tab',
        'label': action.getText('repository.tabs.permissions'),
        'contents': permissionsTabContents
    } /]

    [#assign usagesTab={
        'id': 'linked-repos-usages-tab',
        'label': action.getText('repository.tabs.usages'),
        'contents': usagesTabContents
    } /]

    [#assign bambooSpecsTab={
        'skip': !action.bambooSpecsCapable,
        'id': 'linked-repos-specs-tab',
        'label': action.getText('repository.tabs.bamboo.specs'),
        'contents': bambooSpecsTabContents
    } /]

    <div class="edit-linked-repository-tabs">
        [#-- Show tabbed content for edit mode --]
        [@menu.displayInstantTabbedContent tabs = [
            generalTab,
            permissionsTab,
            usagesTab,
            bambooSpecsTab
        ] /]
    </div>
[#elseif selectedRepository?has_content]
    [#-- Display the contents of general tab only for creation mode --]
    ${generalTabContents}
[#else]
    [#-- Error state, display action errors --]
    [#list actionErrors as error]
        [@ui.messageBox type="error"]${error}[/@ui.messageBox]
    [/#list]
[/#if]

<script>
    require(['jquery'], function ($) {
        var isPermissionTabActive = function () {
            return $('.active-tab > [data-tab-id=linked-repos-permissions-tab]').length > 0;
        };
        var turnOffBambooAsyncForm = function () {
            $('.edit-linked-repository-tabs > .aui-tabs.horizontal-tabs').on('submit', function (event) {
                if (isPermissionTabActive()) {
                    event.stopPropagation();
                }
            })
        };

        //BAMBOO.asyncForm is attached to the whole ConfigureLinkedRepositories container, effectively it intercepts
        //submit events and submit a form, even if there's underlying async component which handles this submit well.
        turnOffBambooAsyncForm();
    });

</script>
</body>
</html>
