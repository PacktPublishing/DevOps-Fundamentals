[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
[#-- @ftlvariable name="expiryConfig" type="com.atlassian.bamboo.build.expiry.CombinedExpiryConfig" --]

[@ui.bambooPanel titleKey='buildExpiry.defaultConfigSection.title' headerWeight='h3']
    [@s.label labelKey='buildExpiry.enable.type' value='${selectedExpiryTypesLabel}' /]

    [#if expiryConfig.duration > 0]
        [@s.label labelKey='buildExpiry.enable.timing' value='${expiryConfig.duration} ${expiryConfig.period}' /]
    [/#if]
[/@ui.bambooPanel]

[@ui.bambooPanel titleKey='buildExpiry.exceptions' headerWeight='h4']
    [@s.label labelKey='buildExpiry.enable.builds' value='${i18n.getText("buildExpiry.enable.builds.perplan", [expiryConfig.buildsToKeep])}' /]

    [#if expiryConfig.labelsToKeep?has_content]
        [#assign labelsToKeep = expiryConfig.labelsToKeep /]
    [#else]
        [#assign labelsToKeep = i18n.getText("buildExpiry.enable.excludeLabels.notUsed") /]
    [/#if]
    [@s.label labelKey='buildExpiry.enable.excludeLabels.labels' value='${labelsToKeep}' /]

    [#if deploymentExpiryEnabled!false]
        [@s.label labelKey='buildExpiry.enable.deployments' value='${i18n.getText("buildExpiry.enable.deployments.perenvironment", [expiryConfig.deploymentsToKeep])}' /]
    [/#if]
[/@ui.bambooPanel]