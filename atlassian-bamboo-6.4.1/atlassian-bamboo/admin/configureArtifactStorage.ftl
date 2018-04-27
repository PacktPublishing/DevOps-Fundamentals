[#--another view of configureArtifactHandlers. Allows to enable only one storage handler per once. See BDEV-8087--]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureArtifactStorage" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureArtifactStorage" --]

<html>
<head>
    [@ui.header pageKey='webitems.system.admin.build.artifactStorage' title=true /]
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="configureArtifactStorage">
    ${webResourceManager.requireResourcesForContext("atl.admin.artifactStorage")}
</head>
<body>
[@ui.header pageKey='webitems.system.admin.build.artifactStorage' /]
[@ui.bambooPanel]
    [@s.text name="admin.artifactstorage.description"]
        [@s.param name="value"][@help.staticUrl pageKey="help.cloud.storage.policy"][@ww.text name="admin.artifactstorage.cloud" /][/@help.staticUrl][/@s.param]
        [@s.param name="value"][@help.href pageKey="help.s3.artifact.storage.configuration"/][/@s.param]
    [/@s.text]
[/@ui.bambooPanel]
[@s.form action="saveArtifactStorage" namespace="/admin" submitLabelKey="global.buttons.update" cancelUri="/admin/configureArtifactStorage.action" showActionMessages='false']
[@s.select labelKey='admin.artifactstorage.location'
    name='selectedArtifactStorage' id='selectedArtifactStorage'
    listKey='first' listValue='second' toggle=true
    list=artifactHandlerDescriptors
    required=true/]

    [#list artifactHandlerModuleDescriptors as moduleDescriptor]
        [#assign editHtml = action.getEditHtml(moduleDescriptor)!/]
        [#assign visible = selectedArtifactStorage==moduleDescriptor.key]
        [#if editHtml?has_content]
            [@ui.bambooSection id='storage-id-${moduleDescriptor.key}'
            dependsOn='selectedArtifactStorage' cssClass="artifact-storage-details"
            showOn=moduleDescriptor.completeKey]
                ${editHtml}
            [/@ui.bambooSection]
        [/#if]
    [/#list]
[/@s.form]
[#if configurationUpdated]
<script type="application/javascript">
    require(['aui/flag'], function(Flag) {
        new Flag({
            type: 'success',
            close: 'auto',
            body: '${action.getText("admin.artifactstorage.configuration.updated")}'
        });
    });
</script>
[/#if]
[#if action.actionMessages?has_content]
<script type="application/javascript">
    require(['aui/flag'], function(Flag) {
        [#list action.actionMessages as artifactHandlerMessage]
            new Flag({
                type: 'info',
                close: 'manual',
                body: '${artifactHandlerMessage}'
            });
        [/#list]
    });
</script>
[/#if]
</body>
</html>