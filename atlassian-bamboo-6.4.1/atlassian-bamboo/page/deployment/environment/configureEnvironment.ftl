[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.ConfigureEnvironment" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.ConfigureEnvironment" --]

[#assign headerText]
    [@ww.text name="deployment.environment.update"]
        [#if environment??]
            [@ww.param]${environment.name?html}[/@ww.param]
        [#else]
            [@ww.param]${id}[/@ww.param]
        [/#if]
    [/@ww.text]
[/#assign]

<html>
<head>
[@ui.header page=headerText title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey="deployments.environments.howtheywork"][@ww.text name="deployments.environments.howtheywork.title"/][/@help.url]</div>
[@ui.header pageKey=headerText headerElement="h2"/]
[@ww.form action="saveEnvironment" namespace="/deploy/config" cancelUri="/deploy/config/configureDeploymentProject.action?id=${deploymentProjectId}"]
    [@ww.hidden name="id"/]

    [@ww.textfield labelKey='deployment.environment.name' name='name' required=true /]
    [@ww.textfield labelKey='deployment.environment.description' name='description' required=false /]

    [#if environment??]
        [#assign toolbar]<a href='[@s.url action="configureEnvironmentTriggers" namespace="/deploy/config" environmentId=environment.id/]'>[@s.text name="deployment.environment.deploy.configure.triggers"/]</a>[/#assign]
    [/#if] [#--if environment--]

    [@ww.param name="buttons"]
        [@ww.text var="backButtonText" name="deployment.environment.update.back"/]
        [@ww.submit value=backButtonText name='save' primary=true /]
    [/@ww.param]
[/@ww.form]

</body>
</html>