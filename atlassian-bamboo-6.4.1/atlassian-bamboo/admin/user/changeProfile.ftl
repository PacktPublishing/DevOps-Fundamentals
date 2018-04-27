[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureProfile" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureProfile" --]
<html>
<head>
	<title>User Profile[#if user??]: [@ui.displayUserFullName user=user /][/#if]</title>
    <meta name="decorator" content="atl.userprofile"/>
    <meta name="tab" content="personalDetails" />
</head>
<body>

    [#assign externallyManaged = action.isExternallyManaged() /]
    [#assign readOnly = action.isUserReadOnly(user) /]

    [#if readOnly || externallyManaged]
        [#assign actionLink='updateExternalProfile' ]
    [#else]
        [#assign actionLink='updateProfile' ]
    [/#if]

[@ww.form action='${actionLink}'
          namespace='/profile'
          submitLabelKey='global.buttons.update'
          cancelUri='/profile/userProfile.action'
          titleKey='user.edit.title']

    [@ww.label labelKey='user.username' name="user.name" /]

    [#if !readOnly && !externallyManaged]
        [@dj.simpleDialogForm
            triggerSelector=".changeEmail"
            width=460 height=260
            submitCallback="reloadThePage"
        /]
        [#assign changeEmailLink]
            <a  id="changeEmail" class="changeEmail" title="${action.getText('user.email.change')}" href="[@ww.url value='/ajax/changeUserEmail.action' returnUrl=currentUrl /]">[@ww.text name='user.email.change' /]</a>
        [/#assign]
        [@ww.textfield labelKey='user.fullName' name="fullName" required=true /]
        [@ww.textfield labelKey='user.email' name="email" readonly=true disabled=true after=changeEmailLink/]
    [#else]
        [@ww.label labelKey='user.fullName' name="fullName" /]
        [@ww.label labelKey='user.email' name="email"  /]
    [/#if]

    [@ww.textfield labelKey='user.jabber' name="jabberAddress" /]

    [@dj.simpleDialogForm
        triggerSelector=".addAlias"
        width=540 height=210
        submitCallback="addAliasSubmitCallback"
    /]
    [#assign addAliasLink]
        <a class="aui-button aui-button-link addAlias" title="${action.getText('user.repositoryAlias.add')}" href="[@ww.url value='/ajax/configureAlias.action' returnUrl=currentUrl /]">[@ww.text name='user.repositoryAlias.add' /]</a>
    [/#assign]

    [@ww.select labelKey='user.repositoryAliases' name='authors'
                list=availableAuthors
                listKey='id'
                listValue='name'
                multiple=true
                size=1
                cssClass='long-field select widget-simple-select2--multiple selectAlias'
                extraUtility=addAliasLink/]

    <script>
        require('widget/simple-select2')('.selectAlias');
    </script>
[/@ww.form]
</body>
</html>
