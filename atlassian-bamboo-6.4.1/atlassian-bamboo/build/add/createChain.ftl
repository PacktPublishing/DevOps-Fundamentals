[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]
[#-- @ftlvariable name="vcsUIConfigBean" type="com.atlassian.bamboo.configuration.repository.VcsUIConfigBean" --]

[#import "/build/common/repositoryCommon.ftl" as rc]
[#import "/lib/chains.ftl" as chain]

<html>
<head>
    <title>[@ww.text name='plan.create' /] - [@ww.text name='plan.create.new.title' /]</title>
    <meta name="tab" content="1"/>
</head>
<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey='plan.create.howtheywork'][@ww.text name='plan.create.howtheywork.title'/][/@help.url]</div>
[@ui.header pageKey="plan.create" headerElement="h2" cssClass="plan.create"/]
<p>[@ww.text name="plan.create.new.description" /]</p>

[#assign canCreateProject = ctx.canCreateProject() /]
[#assign canUseExistingProject = uiConfigBean.existingProjectsForPlanCreation?has_content /]

[#if !canCreateProject && !canUseExistingProject]
    [@chain.noCreatePermissionsInfo/]
[#else]
    [#assign createAction][#if req.getRequestURI()?contains('agentsWizard')]/build/admin/create/agentsWizard/createPlanFromWizard.action[#else]createPlan[/#if][/#assign]
    [@ww.form
        action=createAction
        namespace="/build/admin/create"
        method="post" enctype="multipart/form-data"
        cancelUri="start.action" submitLabelKey="plan.create.tasks.button"
    ]
        <div class="configSection">
            [@ui.bambooSection titleKey="project.details"]
                [#include "/fragments/project/selectCreateProject.ftl"]
                [#include "/fragments/chains/editChainKeyName.ftl"]
            [@s.checkbox fieldLabelKey='chain.access.public.label' labelKey='chain.access.public' name='publicPlanAccess' /]
        [/@ui.bambooSection]

            [#assign hasCreateRepoPermission=fn.hasGlobalPermission("CREATEREPOSITORY")/]
            [#assign linkedRepositories = vcsUIConfigBean.getLinkedRepositoriesForCreate() /]
            [#if hasCreateRepoPermission || linkedRepositories?has_content]
                [@ui.bambooSection id="source-repository" titleKey="repository.create.title"]

                    [#if !repositoryTypeOption?has_content && linkedRepositories?has_content]
                        [#assign repositoryTypeOption = "LINKED" /]
                    [#elseif !repositoryTypeOption?has_content]
                        [#assign repositoryTypeOption = "NEW" /]
                    [#else]
                        [#assign repositoryTypeOption = "NONE" /]
                    [/#if]

                    [@rc.repositorySelector
                        action.getVcsTypeSelectors()
                        linkedRepositories, repositoryTypeOption, selectedRepository, hasCreateRepoPermission
                    /]
                [/@ui.bambooSection]
            [#else]
                [@ww.hidden id="selectedRepository" name="selectedRepository" value="nullRepository"/]
            [/#if]
        </div>
    [/@ww.form]
[/#if]
</body>
</html>