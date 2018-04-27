[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.projects.actions.CloneDeploymentProject" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.projects.actions.CloneDeploymentProject" --]


<html>
<head>
[@ui.header pageKey="deployment.project.clone" title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>


<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.howtheywork"][@ww.text name="deployments.howtheywork.title"/][/@help.url]</div>
[@ui.header pageKey="deployment.project.clone" headerElement="h2" /]

<p>[@s.text name="deployment.project.clone.description" /]</p>

[#if id gt 0]
    [#assign cancelUri="/deploy/config/configureDeploymentProject.action?id=" + id /]
[#else]
    [#assign cancelUri="/deploy/viewAllDeploymentProjects.action" /]
[/#if]

[#assign planPickerId = 'deploymentProjectPlan' /]
[#assign planBranchPickerId = 'deploymentProjectPlanBranch' /]
[#assign planBranchPickerContainerId = '${planBranchPickerId}_container' /]
[#assign planBranchDefaultContainerId= 'branch-default-lozenge' /]
[#assign deploymentProjectNameId = 'deploymentProjectName' /]

[@s.form id="cloneDeploymentProject"
action="saveClonedDeploymentProject" namespace="/deploy/config"
submitLabelKey="deployment.project.clone.button" cancelUri=cancelUri]

    [@s.hidden name="id" /]

    [@ui.bambooSection titleKey="deployment.project.clone.source.details.title" cssClass="project-details" id="cloneProjectInfoSection"]
        [@s.label labelKey='deployment.project.cloned.name' name='deploymentProject.name' cssClass='field-value-normal-font'/]
        [#if deploymentProject.description?has_content]
            [@s.label labelKey='deployment.project.description' name='deploymentProject.description' cssClass='field-value-normal-font'/]
        [/#if]
    [/@ui.bambooSection]

    [@ui.bambooSection titleKey="deployment.project.clone.details.title" cssClass="project-details"]
        [@s.textfield labelKey='deployment.project.cloned.name' name='name' id=deploymentProjectNameId required=true /]
        [@s.textfield labelKey='deployment.project.cloned.description' name='description' cssClass='long-field'  /]
    [/@ui.bambooSection]

[/@s.form]

</body>
</html>