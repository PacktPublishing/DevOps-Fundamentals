[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersionVariables" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersionVariables" --]
[#import "/fragments/variable/variables.ftl" as variables/]
<html>
<head>
    <meta name="decorator" content="deploymentVersionDecorator"/>
    <meta name="tab" content="variables"/>
    [@s.text var='headerText' name='deployment.version.header'][@s.param]${deploymentVersion.name?html}[/@s.param][/@s.text]
    [@ui.header title=true object=deploymentProject.name page=headerText /]
</head>
<body>
<h2>[@ww.text name='deployment.version.variables' /]</h2>
<p>[@ww.text name='deployment.version.variables.description' /]</p>

[#if availableVariables?has_content]
    [@variables.displaySubstitutedVariables id="versionVariables" variablesList=availableVariables/]
[#else]
<p>[@ww.text name='deployment.version.noVariables'/]</p>
[/#if]
</body>
</html>
