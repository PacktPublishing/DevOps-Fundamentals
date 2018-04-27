[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.SystemInfoAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.SystemInfoAction" --]

<html>
<head>
	<title>[@ww.text name='system.title' /]</title>
    <meta name="adminCrumb" content="systemInfo">
</head>
<body>
	<h1>[@ww.text name='system.heading' /]</h1>
    [@ui.bambooPanel titleKey='system.info.title' headerWeight='h3']
        [@ww.label labelKey='system.info.date' name='systemInfo.systemDate' /]
        [@ww.label labelKey='system.info.time' name='systemInfo.systemTime' /]
        [@ww.label labelKey='system.info.uptime' name='systemInfo.uptime' /]
        [@ww.label labelKey='system.info.username' name='systemInfo.userName' /]
        [@ww.label labelKey='system.info.timezone' name='systemInfo.userTimezone' /]
        [@ww.label labelKey='system.info.locale' name='systemInfo.userLocale' /]
        [@ww.label labelKey='system.info.encoding' name='systemInfo.systemEncoding' /]
        [@ww.label labelKey='system.info.os' name='systemInfo.operatingSystem' /]
        [@ww.label labelKey='system.info.osArch' name='systemInfo.operatingSystemArchitecture' /]
        [@ww.label labelKey='system.info.processors' name='systemInfo.availableProcessors' /]
        [@ww.label labelKey='system.info.appServer' name='systemInfo.appServerContainer' hideOnNull='true' /]
    [/@ui.bambooPanel]

    [@ui.bambooPanel titleKey='system.java.title' headerWeight='h3']
        [@ww.label labelKey='system.java.version' value='${systemInfo.getSystemProperty("java.version")}' /]
        [@ww.label labelKey='system.java.vendor' value='${systemInfo.getSystemProperty("java.vendor")}' /]

        [@ww.label labelKey='system.java.specVersion' value='${systemInfo.getSystemProperty("java.vm.specification.version")}' /]
        [@ww.label labelKey='system.java.specVendor' value='${systemInfo.getSystemProperty("java.vm.specification.vendor")}' /]

        [@ww.label labelKey='system.java.jvmVersion' value='${systemInfo.getSystemProperty("java.vm.version")}' /]
        [@ww.label labelKey='system.java.jvmVendor' value='${systemInfo.getSystemProperty("java.vm.vendor")}' /]
        [@ww.label labelKey='system.java.jvmName' value='${systemInfo.getSystemProperty("java.vm.name")}' /]

        [@ww.label labelKey='system.java.jreVersion' value='${systemInfo.getSystemProperty("java.runtime.version")}' /]
        [@ww.label labelKey='system.java.jreName' value='${systemInfo.getSystemProperty("java.runtime.name")}' /]
    [/@ui.bambooPanel]

    [@ui.bambooPanel titleKey="system.network.title" headerWeight='h3']
        [@ww.label labelKey='system.network.hostName' name='systemInfo.hostName' /]
        [@ww.label labelKey='system.network.ipAddress' name='systemInfo.ipAddress' /]
    [/@ui.bambooPanel]

    [@ui.bambooPanel titleKey='system.memory.title' headerWeight='h3']
        [@ww.label labelKey='system.memory.total' value='${systemInfo.totalMemory} MB' /]
        [@ww.label labelKey='system.memory.free' value='${systemInfo.freeMemory} MB' /]
        [@ww.label labelKey='system.memory.used' value='${systemInfo.usedMemory} MB' /]
    [/@ui.bambooPanel]

    [@ui.bambooPanel titleKey='system.bamboo.version' headerWeight='h3']
        [@ww.label labelKey='system.bamboo.version.ver' value=bambooVersion /]
        [@ww.label labelKey='system.bamboo.version.build' value=bambooBuildNumber /]
        [@ww.label labelKey='system.bamboo.version.date' value=bambooBuildDate /]
    [/@ui.bambooPanel]

    [@ui.bambooPanel titleKey='system.bambooPaths.title' headerWeight='h3']
        [@ww.label labelKey='system.bambooPaths.cwd' name='systemInfo.currentDirectory' /]
        [@ww.label labelKey='system.bambooPaths.configurationPath' name='systemInfo.configPath' /]
        [@ww.label labelKey='system.bambooPaths.buildPath' name='systemInfo.buildPath' /]
        [@ww.label labelKey='config.server.buildDirectory' name='systemInfo.buildWorkingDirectory' /]
        [@ww.label labelKey='config.server.artifactsDirectory' name='systemInfo.artifactsDirectory' /]
        [@ww.label labelKey='system.bambooPaths.home' name='systemInfo.applicationHome' /]
        [@ww.label labelKey='system.bambooPaths.logs' value=systemInfo.bambooLogsDirectoryPath /]
        [@ww.label labelKey='system.bambooPaths.temp' name='systemInfo.tempDir' /]
        [@ww.label labelKey='system.bambooPaths.userHome' name='systemInfo.userHome' /]
    [/@ui.bambooPanel]

    [@ui.bambooPanel titleKey='system.rest.title' headerWeight='h3']
        [#assign apiDescription]
            [@ww.text name='system.rest.url']
                [@ww.param]${baseUrl?html}[/@ww.param]
            [/@ww.text]
        [/#assign]
        [@ww.label labelKey='system.rest.label' value=apiDescription escape=false/]
    [/@ui.bambooPanel]

    [@ui.bambooPanel titleKey='system.file.stats' headerWeight='h3']
        [#assign missingFreeDiskSpaceInfo][@ww.text name='system.file.disk.free.failure' /][/#assign]
        [@ww.label labelKey='system.file.disk.free' value=systemInfo.freeDiskSpace!missingFreeDiskSpaceInfo /]
    [/@ui.bambooPanel]

    [@ui.bambooPanel titleKey='system.bamboo.stats' headerWeight='h3']
        [@ww.label labelKey='system.bamboo.plans' name='systemStatisticsBean.numberOfPlans' /]
        [@ww.label labelKey='system.bamboo.results' name='systemStatisticsBean.numberOfResults' /]
        [@ww.label labelKey='system.bamboo.index.time' value='${dateUtils.formatDurationPretty(systemStatisticsBean.approximateIndexTime)}' /]
    [/@ui.bambooPanel]

    [@ui.bambooPanel titleKey='system.jms.title' headerWeight='h3']
        [#if transportConnectors?has_content]
            [#list transportConnectors as transportConnector]
                [@s.label key='system.jms.brokerUri' value='${transportConnector.uri}' /]
            [/#list]
        [#else]
            [@ww.label labelKey='system.jms.remoteBrokerUri' value='Not enabled' /]
        [/#if]
    [/@ui.bambooPanel]

    [#--
    [#if compressionStats?exists]
        [@ui.bambooPanel title='Compression Stats' headerWeight='h3']
            [@ww.label label='Compressed Responses' name='compressionStats.numResponsesCompressed' /]
            [@ww.label label='Compressed Bytes' name='compressionStats.ResponseCompressedBytes' /]
            [@ww.label label='Compression Ratio' name='compressionStats.responseAverageCompressionRatio' /]
        [/@ui.bambooPanel]
    [/#if]
    --]

    [@ui.renderWebPanels location="system.info"/]

    [@ui.bambooPanel titleKey='system.environment.title' headerWeight='h3']
        <ul>
        [#list systemInfo.environmentVariables as env]
           <li>${env!?html}</li>
        [/#list]
        </ul>
    [/@ui.bambooPanel]

    [@ui.bambooPanel titleKey='system.plugins.title' headerWeight='h3']
        <ul>
        [#list enabledPlugins as plugin]
           <li>
               ${plugin.name!?html} - ${((plugin.pluginInformation.version)!"No version")?html}
               <div class="subGrey">Vendor: ${((plugin.pluginInformation.vendorName)!"No Vendor")?html}</div>
           </li>
        [/#list]
        </ul>
    [/@ui.bambooPanel]

</body>
</html>
