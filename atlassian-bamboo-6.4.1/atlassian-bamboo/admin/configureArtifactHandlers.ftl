[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureArtifactHandlers" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureArtifactHandlers" --]
[#import "/templates/plugins/artifactHandler/artifactHandlerCommon.ftl" as artifactHandlerCommon]

<html>
<head>
    <title>[@s.text name='webitems.system.admin.plugins.artifactHandlers' /]</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="configureArtifactHandlers">
</head>
<body>
    <h1>[@s.text name='webitems.system.admin.plugins.artifactHandlers' /]</h1>
    <div class="description">
        [@s.text name='webitems.system.admin.plugins.artifactHandlers.description']
            [@s.param][@help.href pageKey='plugins.artifactHandlers'/][/@s.param]
        [/@s.text]
    </div>

    [@s.form
        action='configureArtifactHandlers!save'
        namespace='/admin'
        cssClass='artifact-handlers-form'
        submitLabelKey='global.buttons.update'
        cancelUri='configureArtifactHandlers.action'
        showActionMessages=false
    ]
        [@artifactHandlerCommon.displayArtifactHandlerEnableDisableTable artifactHandlerDescriptors=artifactHandlerDescriptors/]

        [@ui.header headerElement='h2' pageKey='webitems.system.admin.plugins.artifactHandlers.global.configuration'/]

        [#list artifactHandlerDescriptors as artifactHandlerModuleDescriptor]
            [#assign editHtml = action.getEditHtml(artifactHandlerModuleDescriptor)!""/]
            [#if editHtml?has_content]
                [@ui.bambooSection
                    title=fn.resolveName(artifactHandlerModuleDescriptor.name, artifactHandlerModuleDescriptor.i18nNameKey)
                    description=fn.resolveName(artifactHandlerModuleDescriptor.description, artifactHandlerModuleDescriptor.descriptionKey)
                    cssClass='artifact-handler-configuration'
                    extraAttributes={
                        'data-artifact-handler-type': '${artifactHandlerModuleDescriptor.configurationPrefix}'
                    }
                ]
                    ${editHtml}
                [/@ui.bambooSection]
            [/#if]
        [/#list]
    [/@s.form]

    <script>
        require('page/artifact-handlers')();
    </script>

    [#if action.configurationUpdated]
        [#assign configurationUpdatedMessage]
            [@s.text name='webitems.system.admin.plugins.artifactHandlers.global.configuration.updated.successfully' /]
        [/#assign]
        <script>
            require(['aui/flag'], function(Flag) {
                new Flag({
                    type: 'success',
                    close: 'auto',
                    body: '${configurationUpdatedMessage?js_string}'
                });
            });
        </script>
    [/#if]
    [#if action.actionMessages?has_content]
        <script>
            require(['aui/flag'], function(Flag) {
                [#list action.actionMessages as artifactHandlerMessage]
                    new Flag({
                        type: 'info',
                        close: 'manual',
                        body: '${artifactHandlerMessage?js_string}'
                    });
                [/#list]
            });
        </script>
    [/#if]
</body>
</html>