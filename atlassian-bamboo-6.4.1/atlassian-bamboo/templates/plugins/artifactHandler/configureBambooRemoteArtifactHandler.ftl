[#if ctx.isOnDemandInstance()]
    [#import "/templates/plugins/artifactHandler/artifactHandlerCommon.ftl" as artifactHandlerCommon]

    [@ui.bambooSection titleKey="admin.artifactstorage.local.header"]
        ${i18n.getText("admin.artifactstorage.local.description")}
    [/@ui.bambooSection]
    [#--this part is used in different contexts, so these fields can be not provided by action--]

    [#if ctx.featureManager.onDemandInstance ]
        [#assign takenSpaceInGb = stack.findValue(pluginModuleConfigurationPrefix+':takenSpaceInGb')!0]
        [#assign upperLimitInGb = stack.findValue(pluginModuleConfigurationPrefix+':upperLimitInGb')!1]

        [@artifactHandlerCommon.storageUsageProgressBar usedSpaceInGb=takenSpaceInGb upperLimitInGb=upperLimitInGb/]
    [/#if]
[/#if]
