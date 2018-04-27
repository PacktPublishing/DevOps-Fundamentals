[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.mail.ConfigureMailServer" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.mail.ConfigureMailServer" --]
<html>
<head>
    <title>[@ww.text name='config.email.title' /]</title>
    <meta name="adminCrumb" content="configureEmail">
</head>
<body>
<h1>[@ww.text name='config.email.view.title' /]</h1>

    [@ww.form action='configureMailServer'
    titleKey='config.email.view.current.title'
    submitLabelKey='global.buttons.edit'
    descriptionKey='config.email.view.description']
        [@ww.param name='buttons']
            [@cp.displayLinkButton
                 buttonId="deleteButton"
                 buttonLabel="global.buttons.delete"
                 buttonUrl="${req.contextPath}/admin/deleteMailServer.action"
                 mutative=true
                 cssClass="requireConfirmation"
                 altText="delete this mail server configuration" /]
            [@ww.submit value=action.getText('global.buttons.test') name="sendTest" /]
        [/@ww.param]

        [@ww.label labelKey='config.email.server.name' value=name /]
        [@ww.label labelKey='config.email.from' value=from /]
        [@ww.label labelKey='config.email.subject.prefix' value=prefix /]
        [#if removePrecedence] [#assign precedence='Yes'] [#else]  [#assign precedence='No']  [/#if]
        [@ww.label labelKey='config.email.removePrecedence' value=precedence /]

        [#if hostName?has_content]
            [@ww.label labelKey='config.email.emailSettings' value=smtpChoice /]
            [@ww.label labelKey='config.email.smtp' value=hostName /]
            [#if smtpPort?has_content && smtpPort != "25"]
                [@ww.label labelKey='config.email.smtp.port' value=smtpPort /]
            [/#if]
            [#if userName?has_content]
                [@ww.label labelKey='config.email.user.username' value=userName /]
            [/#if]
            [#if tlsRequired] [#assign tlsText='Yes'] [#else]  [#assign tlsText='No']  [/#if]
            [@ww.label labelKey='config.email.tlsRequired' value=tlsText/]
        [#else]
            [@ww.label labelKey='config.email.emailSettings' value=jndiChoice /]
            [@ww.label labelKey='config.email.jndi.location' value=jndiName /]
        [/#if]
        [@ui.bambooSection titleKey='config.email.test.title' descriptionKey='config.email.test.description']
            [@ww.textfield labelKey='config.email.test.recipient' name="testRecipient" required=false descriptionKey='config.email.test.recipient.description'/]
        [/@ui.bambooSection]
    [/@ww.form]

</body>
</html>
