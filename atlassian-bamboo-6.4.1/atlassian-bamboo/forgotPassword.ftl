[#-- @ftlvariable name="action" type="com.atlassian.bamboo.security.ForgotPassword" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.security.ForgotPassword" --]
<html>
<head>
	<title>[@ww.text name='user.password.reset.title' /]</title>
    <meta name="decorator" content="login" />
</head>
<body>
<header>
    [@ui.header pageKey="user.password.reset.heading" descriptionKey="user.password.reset.description" /]
</header>
[#if mailServerConfigured==false]
    [@ww.form action="userlogin!doDefault.action"
        id="forgotPasswordForm"
        submitLabelKey='global.buttons.back'
        method="post"
        cancelUri='${req.contextPath}/userlogin!doDefault.action'
    ]
        [@ui.messageBox type='warning' titleKey='user.password.reset.noMail']
            [#if ctx.showAdminContactDetailsToAnonymousUsers]
                <a href="[@ww.url action='viewAdministrators' namespace='' /]">
                    [@ww.text name='user.password.reset.contact.administrator' /]
                </a>
            [/#if]
        [/@ui.messageBox]
    [/@ww.form]
[#else]
    [@ww.form action="submitForgotPassword"
        id="forgotPasswordForm"
        submitLabelKey='user.password.reset.button'
        method="post"
        cancelUri='${req.contextPath}/userlogin!doDefault.action'
    ]
        [@ww.textfield labelKey='user.username' name="username" /]
    [/@ww.form]
[/#if]

</body>
</html>