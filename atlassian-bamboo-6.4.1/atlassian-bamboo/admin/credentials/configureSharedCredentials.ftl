[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.credentials.ConfigureSharedCredentials" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.credentials.ConfigureSharedCredentials" --]

<html>
<head>
    [@ui.header pageKey="sharedCredentials.title" title=true/]
    <meta name="adminCrumb" content="sharedCredentialsConfig">
</head>

<body>
<div class="toolbar">
    <div class="aui-toolbar inline">
        <ul class="toolbar-group">
            <li class="toolbar-item">
            [#assign addCredentials][@ww.text name="sharedCredentials.add.button"/][/#assign]
            ${soy.render("aui.buttons.button", {
                "id": "createSharedCredentials",
                "text": "${addCredentials}",
                "dropdown2Target": "dropdown-shared-credentials"
            })}
                <div id="dropdown-shared-credentials" class="aui-dropdown2 aui-style-default" aria-hidden="true"
                     data-dropdown2-alignment="right">
                    <div class="aui-dropdown2-section">
                        <ul class="aui-list-truncate">
                        [#list action.getCredentialTypes() as item]
                            <li><a class="update-credentials"
                                   href="[@ww.url action="addSharedCredentials" namespace="admin" createCredentialsKey=item.completeKey returnUrl=currentUrl/]">${item.name!?html}</a>
                            </li>
                        [/#list]
                        </ul>
                    </div>
                </div>
            </li>
        </ul>
    </div>
</div>
[@ui.header pageKey="sharedCredentials.heading" descriptionKey="sharedCredentials.description"/]

[@ui.bambooPanel]

<div>
    <table class="aui">
        <thead>
        <tr>
            <th>
                [@ww.text name='sharedCredentials.title' /]
            </th>
            <th>
                [@ww.text name="global.heading.type"/]
            </th>
            <th class="operations">
                [@ww.text name="global.heading.actions"/]
            </th>
        </tr>
        </thead>
        <tbody>
            [#if action.getAllCredentials()?has_content]
                [#list action.getCredentialTypes() as credential]
                    [#list action.getCredentials(credential.completeKey) as item]
                        [@credentialsListItem id=item.id name=item.name!?html type=credential.name!?html /]
                    [/#list]
                [/#list]
            [#else]
            <tr>
                <td class="labelPrefixCell" colspan="3">
                    [@ww.text name="sharedCredentials.none"/]
                </td>
            </tr>
            [/#if]
        </tbody>
    </table>
</div>

[/@ui.bambooPanel]


[@dj.simpleDialogForm triggerSelector=".update-credentials" width=600 height=500 submitCallback="reloadThePage"/]
[@dj.simpleDialogForm triggerSelector=".delete" width=560 height=400 headerKey="sharedCredentials.delete" submitCallback="reloadThePage"/]

</body>
</html>

[#macro credentialsListItem id name type]
<tr id="item-${id}">
    <td class="labelPrefixCell">
        ${name}
    </td>
    <td class="labelPrefixCell">
        ${type}
    </td>
    <td class="operations">
        <a class="update-credentials" href="[@ww.url action="editSharedCredentials" namespace="/admin" /]?credentialsId=${id}">[@ww.text name="global.buttons.edit" /]</a> |
        <a href="[@ww.url action="confirmDeleteSharedCredentials" namespace="admin" credentialsId=id returnUrl=currentUrl/]" class="delete" title="[@ww.text name='sharedCredentials.delete' /]">[@ww.text name="global.buttons.delete" /]</a>
    </td>
</tr>
[/#macro]




