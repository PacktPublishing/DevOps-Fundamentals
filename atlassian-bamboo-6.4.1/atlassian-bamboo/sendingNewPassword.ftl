[#-- @ftlvariable name="action" type="com.atlassian.bamboo.security.ForgotPassword" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.security.ForgotPassword" --]

<html>
<head>
    <title>[@ww.text name='user.password.reset.mailsent.title' /]</title>
    <meta name="decorator" content="install" />
</head>

<body>
    <h1>[@ww.text name='user.password.reset.mailsent.heading' /]</h1>
    [@ui.messageBox type="info"]
        [@ww.text name='user.password.reset.mailsent.text' /]
        [#if ctx.showAdminContactDetailsToAnonymousUsers]
            [@ww.text name='user.password.reset.mailsent.contactAdministrators']
                [@ww.param][@ww.url action='viewAdministrators' namespace='' /][/@ww.param]/]
            [/@ww.text]
        [/#if]
    [/@ui.messageBox]
</body>
</html>