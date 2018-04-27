[#-- @ftlvariable name="adminErrorsBean" type="com.atlassian.bamboo.logger.AdminErrorAction" --]
[#assign adminErrorsBean = webwork.bean("com.atlassian.bamboo.logger.AdminErrorAction") ]
[#assign adminErrors = adminErrorsBean.adminErrors ]

[#if !adminErrors.empty]
    [#list adminErrors.entrySet() as error]
        [@ui.messageBox cssClass="admin-errors" type="warning"]
            [#if fn.hasAdminPermission() ]
                <a class="adminErrorBoxLinks mutative" href="[@s.url namespace='/' action='removeAdminError' errorKey=error.key /]">Acknowledge</a>
            [/#if]
            ${error.value}
        [/@ui.messageBox]
    [/#list]
[/#if]
