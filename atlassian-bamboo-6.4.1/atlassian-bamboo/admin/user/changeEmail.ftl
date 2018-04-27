[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.ChangeEmail" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.ChangeEmail" --]
[@ww.form action="saveUserEmail" namespace='/ajax'
    submitLabelKey="global.buttons.update"]
    [@ww.hidden name="returnUrl" /]

    [@ww.textfield labelKey='user.changeEmail.email' name="email" required=true /]
    [@ww.password labelKey='user.changeEmail.password' name="password" required=true /]

[/@ww.form]
