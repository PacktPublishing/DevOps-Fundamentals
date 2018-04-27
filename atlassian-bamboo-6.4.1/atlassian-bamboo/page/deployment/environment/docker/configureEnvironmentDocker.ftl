[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.docker.ConfigureEnvironmentDocker" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.docker.ConfigureEnvironmentDocker" --]
[#import "/fragments/docker/docker.ftl" as docker/]
[#assign headerText = i18n.getText("deployment.environment.docker.title", [(environment.name)!""]) /]

<html>
<head>
    [@ui.header page=headerText title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>
    [@ui.header page=headerText headerElement="h2"/]

    [#if action.hasActionErrors()]
        [#list formattedActionErrors as error]
            [@ui.messageBox type="error"]${error}[/@ui.messageBox]
        [/#list]
    [#else]
        [@s.url var="cancelUri" action="configureDeploymentProject" namespace="deploy/config"]
            [@s.param name="id" value="${deploymentProject.id}" /]
            [@s.param name="environmentId" value="${environment.id}" /]
        [/@s.url]
        [@s.form
            id="configureDocker"
            action="saveEnvironmentDocker"
            namespace="/deploy/config"
            submitLabelKey="global.buttons.update"
            cancelUri="deploy/config/configureDeploymentProject.action?id=${deploymentProject.id}&environmentId=${environment.id}"]

            [@s.hidden name="environmentId" /]

            [@docker.dockerEditConfigurationFragment
                headerKey="deployment.environment.docker.isolate.header"
                descriptionKey="deployment.environment.isolate.description"
                isolationTypeRadioLabelKey="deployment.environment.isolate.deploy.release.radio"
                isolationTypeRadioName="isolationType"
                isolationOptions=environmentIsolationOptions
                dataVolumes=dataVolumes /]
        [/@s.form]
    [/#if]
</body>
</html>
