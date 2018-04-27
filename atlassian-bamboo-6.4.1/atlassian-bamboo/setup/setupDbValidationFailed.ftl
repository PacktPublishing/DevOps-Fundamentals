[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupDatabaseAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupDatabaseAction" --]
<html>
<head>
    <title>[@s.text name='error.title' /]</title>
    <meta name="decorator" content="install" />
    <meta name="step" content="${waitStep}">
</head>
<body>
<p>[@s.text name='error.events.present' /]</p>

<table class="aui grid" id="dbValidationErrors">
    <thead>
    <tr>
        <th>[@s.text name="setup.install.database.validationFailed.description" /]</th>
    </tr>
    </thead>
    [#list actionErrors as error]
        <tr>
            <td>
            ${htmlUtils.getTextAsHtml(error)}
            </td>
        </tr>
    [/#list]
</table>

<p>[@s.text name="setup.install.database.validationFailed.contact.support" /]</p>
</body>
</html>