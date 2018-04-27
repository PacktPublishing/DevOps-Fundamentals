[@ww.text var="title" name="deployment.environment.plugin.config.title"]
    [@ww.param][#if environment??]${environment.name?html}[#else]Unknown[/#if][/@ww.param]
[/@ww.text]

<html>
<head>
[@ui.header pageKey=title title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>

[@ui.header pageKey=title headerElement="h2"/]

[#if environment?has_content]

    <div class="aui-group">
        <div class="aui-item formArea">
        [@ww.form action='updateEnvironmentMiscellaneous' submitLabelKey='global.buttons.update' cssClass='top-label'
            cancelUri='/deploy/config/configureDeploymentProject.action?id=${environment.deploymentProjectId}&environmentId=${environment.id}']
                [@ww.hidden name='environmentId' /]

                [#assign pluginPages = customEnvironmentPluginConfigEditHtmlList/]
                [#if pluginPages?has_content]
                    [#list pluginPages as pluginPage]
                        ${pluginPage}
                    [/#list]
                [#else]
                    [@ui.displayText key='deployment.environment.plugin.config.noContent'/]
                [/#if]

            [/@ww.form]
        </div>
        </div>
    </div>

[#else]
[#-- Error state, display action errors --]
    [#list actionErrors as error]
        [@ui.messageBox type="error"]${error}[/@ui.messageBox]
    [/#list]
[/#if]


</body>
</html>