[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]

[#import "/lib/chains.ftl" as chain]
${webResourceManager.requireResourcesForContext("bamboo.configuration")}

<html>
<head>
    <title>[@s.text name='plan.create.clone.title' /]</title>
    <meta name="decorator" content="atl.general"/>
    <meta name="topCrumb" content="create"/>
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey='plan.clone.howtheywork'][@s.text name='plan.clone.howtheywork.title'/][/@help.url]</div>
[@ui.header pageKey="plan.create.clone.title" headerElement="h2" cssClass="plan.create.clone.title" /]
<p>[@s.text name="plan.create.clone.description" /]</p>

[#assign canCreateProject = ctx.canCreateProject() /]
[#assign canUseExistingProject = uiConfigBean.existingProjectsForPlanCreation?has_content /]

[#if !canCreateProject && !canUseExistingProject]
    [@chain.noCreatePermissionsInfo/]
[#else]
    [@s.form action="performClonePlan" namespace="/build/admin/create"
              cancelUri='start.action'
              submitLabelKey='Create']

            [@ui.bambooSection titleKey="chain.clone.list"]
                [#if plansToClone?has_content]
                    [@s.select labelKey='chain.clone.list' name='planKeyToClone' id='planKeyToClone'
                        list='plansToClone' listKey='key' listValue='buildName' groupBy='project.name']
                    [/@s.select]
                [#else]
                    [@ui.messageBox type="warning"][@s.text name="chain.clone.list.empty" /][/@ui.messageBox]
                [/#if]
            [/@ui.bambooSection]

            <script>
                require('widget/simple-select2')('[name="planKeyToClone"]');
            </script>

            [@ui.bambooSection titleKey="project.details.clone"]
                [#include "/fragments/project/selectCreateProject.ftl"]
            [/@ui.bambooSection]

            [@ui.bambooSection titleKey="build.details"]

                    [#include "/fragments/chains/editChainKeyName.ftl"]

                [@s.hidden name="clonePlan" value="true"/]
            [/@ui.bambooSection]

    [/@s.form]
    <script type="text/javascript">
        AJS.$(function ($) {
            var $projectDropdown = $('#performClonePlan_existingProjectKey');
            var handlePlanSelection = function () {
                var selectedProjectKey = $(this).val().split('-')[0];
                $projectDropdown.val(selectedProjectKey);
            };
            var $planToClone = $('#performClonePlan_planKeyToClone').change(handlePlanSelection);
            if (${(!existingProjectKey?has_content)?string}) {
                handlePlanSelection.call($planToClone[0]);
            }
        });
    </script>
[/#if]
</body>
</html>