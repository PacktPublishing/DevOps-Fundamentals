[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.CloneEnvironment" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.CloneEnvironment" --]

[#assign headerText]
    [@ww.text name="deployment.environment.clone"]
        [@ww.param]
            [#if deploymentProject??]
            ${deploymentProject.name?html}
            [#else]
            ${deploymentProjectId}
            [/#if]
        [/@ww.param]
        [@ww.param]
            [#if sourceEnvironment??]
                ${sourceEnvironment.name?html}
            [#else]
                ${sourceEnvironmentId}
            [/#if]
        [/@ww.param]
    [/@ww.text]
[/#assign]

<html>
<head>
[@ui.header page=headerText title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-large"/>
</head>
<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.environments.howtheywork"][@ww.text name="deployments.environments.howtheywork.title"/][/@help.url]</div>

[@ui.header page=headerText headerElement="h2"/]

[@ww.form   action="saveClonedEnvironment"
            namespace="/deploy/config"
            submitLabelKey="deployment.environment.clone.button"
            cancelUri="/deploy/config/configureDeploymentProject.action?id=${deploymentProjectId}"]
    [@ww.hidden name="deploymentProjectId"/]
    [@ww.hidden name="sourceEnvironmentId"/]

    [@ui.bambooSection titleKey="deployment.environment.clone.source.details" cssClass="project-details" id="cloneEnvironmentInfoSection"]
        [@s.label labelKey='deployment.environment.name' name='sourceEnvironment.name'  cssClass='field-value-normal-font'/]
        [#if sourceEnvironment.description?has_content]
            [@s.label labelKey='deployment.environment.description' name='sourceEnvironment.description' cssClass='field-value-normal-font'/]
        [/#if]
    [/@ui.bambooSection]

    [@ui.bambooSection titleKey="deployment.environment.cloned.details" cssClass="project-details"]
        [@ww.textfield labelKey='deployment.environment.name' name='name' required=true /]
        [@ww.textfield labelKey='deployment.environment.description' name='description' cssClass='long-field' required=false /]
    [/@ui.bambooSection]
[/@ww.form]

</body>
</html>