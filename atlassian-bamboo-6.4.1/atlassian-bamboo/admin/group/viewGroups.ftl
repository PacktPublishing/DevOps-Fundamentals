[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.group.ConfigureGroup" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.group.ConfigureGroup" --]
<html>
<head>
    <title>[@ww.text name='group.admin.manage.title' /]</title>
    <meta name="adminCrumb" content="groupConfig">
</head>

<body>

[@ui.header pageKey="group.admin.manage.heading" descriptionKey="group.admin.manage.description"/]

[@ww.action name="browseGroups" namespace="/admin/group" executeResult="true" /]

[#if !action.isExternallyManaged()]

    [@ww.action name="addGroup" executeResult="true" /]

[/#if]




</body>
</html>