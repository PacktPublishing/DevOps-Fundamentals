[#-- @ftlvariable name="errors" type="com.atlassian.bamboo.logger.SystemErrorList" --]

[#if fn.hasAdminPermission() ]

[#assign errors = webwork.bean("com.atlassian.bamboo.logger.SystemErrorList")]

[#if errors.systemErrors?has_content]
    [@ww.url var='systemErrorsURL' action='systemErrors' namespace='/admin' /]
    <p><img src="${req.contextPath}/images/icons/warning_16.gif" alt="Errors have been detected" width="16" height="16" style="vertical-align: middle;">
        [@s.text name='system.errors.description.dashboard']
            [@s.param value=errors.systemErrors.size() /]
            [@s.param]${systemErrorsURL}[/@s.param]
        [/@s.text]
    </p>
[/#if]

[/#if]
