[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.AdministerAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.AdministerAction" --]
[#-- @ftlvariable name="errorsBean" type="com.atlassian.bamboo.logger.SystemErrorList" --]
<html>
<head>
    <title>[@s.text name='system.errors.title' /]</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="systemErrors">
</head>
<body>

[#assign errorsBean = webwork.bean("com.atlassian.bamboo.logger.SystemErrorList")]
[#assign systemErrors = errorsBean.getSystemErrors(10000)]

<h1>[@s.text name='system.errors.heading' /]</h1>

[#if systemErrors?has_content]
    <span class="floating-toolbar">
        <a class="aui-button mutative" id="clearAllErrors" href="[@s.url namespace="/" action='removeAllErrorsFromLog' returnUrl='${currentUrl}'/]">[@s.text name='system.errors.clear'/]</a>
    </span>
[/#if]

<p>
    [@s.text name='system.errors.description']
        [@s.param value=systemErrors.size() /]
    [/@s.text]
</p>


[#list systemErrors?sort_by("lastOccurred")?reverse as error]
    [@cp.showSystemError error=error returnUrl=currentUrl webPanelLocation='system.errors'/]
[/#list]

</body>

</html>
