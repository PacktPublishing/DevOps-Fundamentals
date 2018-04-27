[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ConfigureSecurity" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ConfigureSecurity" --]

[#macro rssSecuritySettings isReadOnly]
    [@ui.bambooSection]
    <h3>[@s.text name='config.security.rss.title' /] [@help.icon pageKey='security.rss' /]</h3>
        [@s.checkbox labelKey='config.security.rss.enable' name='rssEnabled' toggle=true disabled=isReadOnly/]

        [@ui.bambooSection dependsOn='rssEnabled' showOn=true ]

            [#-- use docker --]
            [@s.checkbox labelKey='config.security.rss.execute.specs.in.docker' name='rssExecuteSpecsInDocker' toggle=true disabled=isReadOnly/]
            [@ui.bambooSection dependsOn='rssExecuteSpecsInDocker' showOn=true ]

                [#if !dockerConfigured]
                    [@ww.text var='rssMissingDocker' name='config.security.rss.docker.not.configured']
                        [@ww.param][@ww.url action='configureSharedLocalCapabilities' namespace='/admin/agent'/][/@ww.param]
                        [@ww.param][@help.href pageKey='security.rss'/][/@ww.param]
                    [/@ww.text]
                    <div class="field-group">
                        [@ui.messageBox type='warning' title=rssMissingDocker/]
                    </div>
                [/#if]

                [@s.textfield name='rssDockerImage' labelKey='config.security.rss.docker.image' cssClass='long-field'
                    required=true disabled=isReadOnly description=action.rssDockerImageDescription /]
            [/@ui.bambooSection]

        [/@ui.bambooSection]
    [/@ui.bambooSection]

[/#macro]