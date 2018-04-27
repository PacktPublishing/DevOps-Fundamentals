[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
[#-- @ftlvariable name="expiryConfig" type="com.atlassian.bamboo.build.expiry.CombinedExpiryConfig" --]

[#assign nextFireTimeText]

    [#if action.trigger?has_content]

        [#assign nextFireTime = (action.trigger.nextFireTime)! /]

        [#if nextFireTime?has_content]
            ${(nextFireTime?datetime)}
            <span class="small grey">(in ${durationUtils.getRelativeToDate(nextFireTime.time)})</span>
        [#else]
            [@s.text name='elastic.schedule.noFireTime' /]
        [/#if]

    [#else]
        [@s.text name='elastic.schedule.noFireTime' /]
    [/#if]

[/#assign]

<html>
<head>
    <title>[@s.text name='buildExpiry.title' /]</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="buildExpiry">
</head>
<body>
<div id="viewExpiryPanel">
[#assign headerDescription]
    [@s.text name="buildExpiry.description"]
        [@s.param][@help.href pageKey="expiry.global"/][/@s.param]
    [/@s.text]
[/#assign]

[@ui.header pageKey='buildExpiry.heading' description='${headerDescription}' /]

[@s.form action='buildExpiry!edit.action' submitLabelKey='global.buttons.edit']
    [#if !deploymentExpiryEnabled]
        [#include "/admin/build/viewDeploymentExpiryWarning.ftl" /]
    [/#if]

    [#if expiryConfig.enabled]
        [#include "/admin/build/viewBuildExpiryFragment.ftl" /]
    [#else]
        [@ui.bambooPanel titleKey="buildExpiry.defaultConfigSection.title" headerWeight='h3']
            <p>[@s.text name='buildExpiry.disabled' /]</p>
        [/@ui.bambooPanel]
    [/#if]

    [#if expiryConfig.cronExpression?has_content]
        [@ui.bambooPanel titleKey='buildExpiry.cronSection' descriptionKey='buildExpiry.enable.cronSection.details' headerWeight='h3']
            [@s.label labelKey='cronEditorBean.label' value='${action.getPrettyCronExpression(expiryConfig.cronExpression)!}' /]
            [@s.label labelKey='buildExpiry.nextFireTime' value='${nextFireTimeText!}' escape="false"/]
        [/@ui.bambooPanel]
    [/#if]

    [@s.param name='buttons']
        [@cp.displayLinkButton buttonId="runButton" buttonLabel="global.buttons.run.now" buttonUrl='${req.contextPath}/admin/runBuildExpiry.action' mutative=true/]
    [/@s.param]
[/@s.form]
</div>
</body>
</html>
