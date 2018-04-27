[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]

<html>
<head>
	<title>[@s.text name='buildExpiry.title' /]</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="buildExpiry">
</head>
<body>

	<h1>[@s.text name='buildExpiry.heading' /]</h1>

    <p class="description">
        [@s.text name="buildExpiry.description"]
            [@s.param][@help.href pageKey="expiry.global"/][/@s.param]
        [/@s.text]
    </p>

    [@s.form id='buildExpiryForm' action='buildExpiry.action' cancelUri='/admin/buildExpiry!read.action' submitLabelKey='global.buttons.update']

        [#if !deploymentExpiryEnabled]
            [#include "/admin/build/viewDeploymentExpiryWarning.ftl" /]
        [/#if]

        [@ui.bambooSection titleKey="buildExpiry.defaultConfigSection.title"]

            [@ui.displayText]
                [@s.text name="buildExpiry.defaultConfigSection.description"]
                    [@s.param][@help.href pageKey="expiry.global"/][/@s.param]
                [/@s.text]
            [/@ui.displayText]

            [@ui.bambooSection]
                [#if !deploymentExpiryEnabled]
                    [#include "/admin/build/editBuildExpiryForm.ftl" /]
                [#else ]
                    [#include "/admin/build/editBuildExpiryFormDeployment.ftl" /]
                [/#if]
            [/@ui.bambooSection]

        [/@ui.bambooSection]

        [@ui.bambooSection titleKey="buildExpiry.cronSection"]

            [@s.text name="buildExpiry.enable.cronSection.details" /]
            [@dj.cronBuilder name='expiryConfig.cronExpression' /]

        [/@ui.bambooSection]

    [/@s.form]

</body>
</html>
