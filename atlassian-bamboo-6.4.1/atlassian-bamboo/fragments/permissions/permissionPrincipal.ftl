[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.AddPermissionAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.AddPermissionAction" --]

[@s.form action="createPermissionPrincipal" namespace="/ajax"
        cssClass="bambooAuiDialogForm"
        submitLabelKey='global.buttons.add'
        cancelUri="${returnUrl}"]

    [@s.hidden name='principalType' toggle='true' /]

    [@ui.bambooSection dependsOn='principalType' showOn='User']
        [@s.textfield labelKey='build.permission.form.add.title' name='newUser' template='userPicker' multiSelect=false /]
    [/@ui.bambooSection]

    [@ui.bambooSection dependsOn='principalType' showOn='Group']
        [@s.textfield labelKey='build.permission.form.add.title' name='newGroup' /]
    [/@ui.bambooSection]

    [@s.hidden name='entityId' /]
    [@s.hidden name='javaType' /]
    [@s.hidden name='returnUrl' /]
    [@s.hidden name='permissionToGrant' /]
[/@s.form]
