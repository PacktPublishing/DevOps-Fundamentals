[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.CreateEnvironment" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.CreateEnvironment" --]

[#import "/fragments/docker/docker.ftl" as docker/]

[#assign headerText]
    [@ww.text name="deployment.environment.create"]
        [@ww.param]
            [#if deploymentProject??]
                ${deploymentProject.name?html}
            [#else]
                ${deploymentProjectId}
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
[@ww.form action="saveCreatedEnvironment" namespace="/deploy/config" cancelUri="/deploy/config/configureDeploymentProject.action?id=${deploymentProjectId}"]
    [@ww.hidden name="deploymentProjectId"/]

    <p>
        [@s.text name="deployment.environment.create.description"/]
    </p>

    [@ui.header headerElement="h3" pageKey="deployment.environment.details" /]

    [@ww.textfield labelKey='deployment.environment.name' name='name' required=true /]
    [@ww.textfield labelKey='deployment.environment.description' name='description' required=false /]

    [#if createTriggerEnabled]

        [@ui.header headerElement="h3" pageKey="deployment.environment.continuous.details" /]

        <p class="heading-description">
            [@s.text name="deployment.environment.continuous.details.description" /]
        </p>

        [@s.checkbox id="deployContinuously" name="deployContinuously" labelKey="deployment.environment.deploy.continuously" toggle=true/]
        [@ui.bambooSection dependsOn="deployContinuously"]
            [#include "/build/common/configureTrigger.ftl"]
            [@configureTrigger deployment=true/]
        [/@ui.bambooSection]
    [/#if]

    [@docker.dockerCreateConfigurationFragment
        headerKey='deployment.environment.docker.isolate.header'
        descriptionKey='deployment.environment.isolate.description'
        isolationTypeRadioLabelKey='deployment.environment.isolate.deploy.release.radio'
        isolationTypeRadioName='deploymentEnvironmentIsolation'
        isolationOptions=action.environmentIsolationOptions/]

    [@ww.param name="buttons"]
        [@ww.text var="saveButtonText" name="deployment.environment.save.back"/]
        [@ww.submit value=saveButtonText name='save' primary=true /]
    [/@ww.param]
[/@ww.form]

</body>
</html>