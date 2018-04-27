[#-- @ftlvariable name="artifactHandlerDescriptors" type="java.util.List<com.atlassian.bamboo.plugin.descriptor.ArtifactHandlerModuleDescriptor>" --]
[#-- @ftlvariable name="configurationPrefix" type="java.lang.String" --]
[#if featureManager.artifactHandlerUiEnabled]
    [#import "artifactHandlerCommon.ftl" as artifactHandlerCommon]
    <h3>[@s.text name='webitems.system.admin.plugins.artifactHandlers' /]</h3>

    [@s.checkbox key='webitems.system.admin.plugins.artifactHandlers.custom' name=configurationPrefix+'useCustomArtifactHandlers' toggle=true /]

    [@ui.bambooSection dependsOn=configurationPrefix+'useCustomArtifactHandlers' showOn=true]
        <div class="field-group">
            [@artifactHandlerCommon.displayArtifactHandlerEnableDisableTable artifactHandlerDescriptors=artifactHandlerDescriptors configurationForPlan=true /]
        </div>
    [/@ui.bambooSection]
[#else]
    [@s.hidden name=configurationPrefix+'useCustomArtifactHandlers' value=false /]
[/#if]
