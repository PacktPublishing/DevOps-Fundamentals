[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]

<html>
<head>
    <title>[@ww.text name='dashboard.title' /]</title>
    <meta name="decorator" content="instanceName"/>
    ${webResourceManager.requireResourcesForContext("atl.dashboard")}
</head>
<body>

[#assign hasUser = user?? /]
[#assign hasAdminPermission = fn.hasAdminPermission() /]
${soy.render('bamboo.feature.dashboard.welcomeMat.welcomeMat', {
    "hasUser": hasUser,
    "hasAdminPermission": hasAdminPermission,
    "canCreatePlan": ctx.canCreatePlan(),
    "importOptions": ctx.getWebItems('system.welcome/welcomeImportOptions', req)
})}
</body>
</html>
