[#macro displayArtifactHandlerEnableDisableTable artifactHandlerDescriptors configurationForPlan=false]
[#-- @ftlvariable name="artifactHandlerDescriptors" type="java.util.List<com.atlassian.bamboo.plugin.descriptor.ArtifactHandlerModuleDescriptor>" --]
<table class="aui artifact-handlers-table">
    <thead>
    <tr>
        <th>[@s.text name='webitems.system.admin.plugins.artifactHandlers.table.header.name' /]</th>
        <th class="checkboxCell">[@s.text name='webitems.system.admin.plugins.artifactHandlers.table.header.enabled.for.shared' /]</th>
        <th class="checkboxCell">[@s.text name='webitems.system.admin.plugins.artifactHandlers.table.header.enabled.for.non.shared' /]</th>
        [#if configurationForPlan]
        <th></th>
        [/#if]
    </tr>
    </thead>
<tbody>
[#list artifactHandlerDescriptors as artifactHandlerDescriptor]
    [#assign key=artifactHandlerDescriptor.key /]
    <tr data-artifact-handler-type="${artifactHandlerDescriptor.configurationPrefix}">
        <td>${artifactHandlerDescriptor.name}</td>
        <td class="checkboxCell">[@s.checkbox name='${artifactHandlerDescriptor.configurationPrefix}:enabledForShared' theme='simple'/]</td>
        <td class="checkboxCell">[@s.checkbox name='${artifactHandlerDescriptor.configurationPrefix}:enabledForNonShared' theme='simple'/]</td>
        [#if configurationForPlan]
        <td>
            [#assign configurationCompleteKey]${artifactHandlerDescriptor.configurationPrefix}:configurationComplete[/#assign]
            [#if !.vars[configurationCompleteKey]]
                [@ui.lozenge colour='error' textKey='webitems.system.admin.plugins.artifactHandlers.table.error.configuration.missing' showTitle=false/]
                <span class="aui-icon aui-icon-help" data-aui-trigger aria-controls="configuration-missing-dialog-${key}"></span>
                <aui-inline-dialog id="configuration-missing-dialog-${key}" alignment="bottom right" responds-to="hover">
                    <p>[@s.text name='webitems.system.admin.plugins.artifactHandlers.table.error.configuration.missing.dialog'/]</p>
                </aui-inline-dialog>
            [/#if]
        </td>
        [/#if]
    </tr>
[/#list]
</tbody>
</table>
[/#macro]

[#--this macro can only be used once on every page--]
[#macro storageUsageProgressBar usedSpaceInGb upperLimitInGb]
    [#assign leftSpace = upperLimitInGb - usedSpaceInGb]
    [#if leftSpace < 0]
        [#assign leftSpace = 0]
    [/#if]
    [#if upperLimitInGb == 0]
        [#assign usedCapacity = 1]
    [#else]
        [#assign usedCapacity = usedSpaceInGb/upperLimitInGb]
    [/#if]

    [#if usedCapacity > 1]
        [#assign usedCapacity = 1]
    [/#if]
    <div id="storageCapacityProgress"></div>
    <table id="spaceUsage">
        <tr>
            <td width="30%">
                <div class="usedSpaceCircle [#if usedCapacity==1]error[/#if]"></div>
                <span id="usedSpace">${i18n.getText('admin.artifactstorage.local.used', [usedSpaceInGb?string['0.#']!0])}</span>
            </td>
            <td width="30%">
                <div class="leftSpaceCircle"></div>
                <span id="leftSpace">${i18n.getText('admin.artifactstorage.local.left', [leftSpace?string['0.#']!'25'])}</span>
            </td>
            <td width="40%" style="text-align: right">
                <strong>${i18n.getText('admin.artifactstorage.local.total', [upperLimitInGb?string['0.#']!'25'])}</strong>
            </td>
        </tr>
    </table>

    <script type="text/javascript">
        require(['jquery', 'widget/progress-bar', 'page/artifact-storage-config'], function($, ProgressBar, ArtifactStorageConfig) {
            new ProgressBar({
                el: "#storageCapacityProgress",
                value: +(${usedCapacity})
            });
            [#if usedCapacity == 1 && selectedArtifactStorage == 'com.atlassian.bamboo.plugin.artifact.handler.remote:BambooRemoteArtifactHandler']
                return new ArtifactStorageConfig({
                    target: '#selectedArtifactStorage'
                });
            [/#if]
        });
</script>
[/#macro]