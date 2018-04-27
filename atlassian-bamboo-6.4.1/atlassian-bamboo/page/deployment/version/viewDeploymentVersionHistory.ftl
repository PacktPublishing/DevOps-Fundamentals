[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersion" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.versions.actions.ViewDeploymentVersion" --]

<html>
<head>
    <meta name="decorator" content="none"/>
</head>
<body>
${soy.render("bamboo.deployments:view-deployment-version", "bamboo.page.deployment.version.deploymentStatus", {
"deploymentVersion": deploymentVersion,
"deploymentProject": deploymentProject,
"deploymentEnvironmentStatuses": versionDeploymentStatuses,
"currentUrl" : currentUrl,
"hideActions": true
})}
</body>
</html>
