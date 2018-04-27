[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewAgentAdmin" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewAgentAdmin" --]

[#import "/agent/commonAgentFunctions.ftl" as agt]

<html>
<head>
    <title>
    [@ww.text name='agent.view.heading.' + agent.type.identifier /]
    [#switch agent.type.identifier]
    [#case "local"]
        [@ww.url var='sharedCapabilityUrl' action='configureSharedLocalCapabilities' namespace='/admin/agent' /]
    [#break]
    [#case "remote"]
        [@ww.url var='sharedCapabilityUrl' action='configureSharedRemoteCapabilities' namespace='/admin/agent' /]
    [#break]
    [#case "elastic"]
    [#break]
    [/#switch]
    - ${agent.name?html}
    </title>
    [@ww.url value='/admin/agent/viewAgents.action' var='agentsListUrl' /]    
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="agentsConfig">
</head>

<body>
[@agt.header /]
[@agt.agentDetails headerKey='agent.details' agentId=agent.id showOptions="all" /]

[#switch agent.type.identifier]
    [#case "local"]
    [#case "remote"]
        [#assign tabs=['agent.capabilities', 'agent.builds.execute', 'agent.environments.execute', 'system.info.title', 'auditlog.agent', 'system.errors.title'] /]
        [#break]
    [#case "elastic"]
        [#assign tabs=['elastic.image.capabilities', 'agent.builds.execute', 'agent.environments.execute', 'system.info.title', 'auditlog.agent', 'system.errors.title'] /]
        [#break]
[/#switch]

[@dj.tabContainer headingKeys=tabs selectedTab='${selectedTab!}' analyticsEvent='bamboo.page.adminViewAgent.tabsactivate']
    [#switch agent.type.identifier]
    [#case "local"]
    [#case "remote"]
        [@dj.contentPane labelKey='agent.capabilities']
            [#-- Specific Capabilities --]
            [@ww.url action='configureAgentCapability' namespace='/admin/agent' agentId='${agentId}' var='addCapabilityUrl' /]
            [@ui.bambooPanel titleKey='agent.capability.specific.title' descriptionKey='agent.capability.specific.description'
                             tools='<a id="addCapability" href="${addCapabilityUrl}">${action.getText("agent.capability.add")}</a>']
                [#if capabilitySet?? && capabilitySet.capabilities?has_content]
                    <p>[@ww.text name='agent.capability.specific.prefix' /]</p>
                    [@agt.displayCapabilities capabilitySetDecorator=capabilitySetDecorator
                                             addCapabilityUrlPrefix=addCapabilityUrl
                                             showDelete=true /]
                    [#assign showDesc = false /]
                [#else]
                    [#assign showDesc = true /]
                    <p>[@ww.text name='agent.capability.specific.empty' /]</p>
                [/#if]
            [/@ui.bambooPanel]


            [#-- Shared Capabilities --]
            [#if (fn.hasGlobalAdminPermission())]
                [#assign editLink]
                    <a  id="addSharedCapability" href="${sharedCapabilityUrl}">${action.getText("global.buttons.edit")}</a>
                [/#assign]
            [#else]
                [#assign editLink='']
            [/#if]

            [@ui.bambooPanel titleKey='agent.capability.inherited.shared.title' descriptionKey='agent.capability.inherited.shared.description' tools=editLink]
                [#if sharedCapabilitySet?? && sharedCapabilitySet.capabilities?has_content]
                    [@agt.displayCapabilities capabilitySetDecorator=sharedCapabilitySetDecorator addCapabilityUrlPrefix='' showDescription=showDesc/]
                [#else]
                    <p>[@ww.text name='agent.capability.inherited.shared.empty' /]</p>
                [/#if]
            [/@ui.bambooPanel]
        [/@dj.contentPane]

        [@dj.contentPane labelKey='agent.builds.execute']
            [@agt.executablesPaneContent action="viewAgentExecutableJobs" selector="#Executablejobs" id=agentId/]
        [/@dj.contentPane]

        [@dj.contentPane labelKey='agent.environments.execute']
            [@agt.executablesPaneContent action="viewAgentExecutableDeployments" selector="#Executabledeploymentenvironments" id=agentId/]
        [/@dj.contentPane]
    [#break]

    [#case "elastic"]
        [#assign image=agent.elasticImageConfiguration]
        [@dj.contentPane labelKey='elastic.image.capabilities']
            [@agt.capabilitiesElasticAgent capabilitySet capabilitySetDecorator /]
        [/@dj.contentPane]

        [@dj.contentPane labelKey='agent.builds.execute']
            [@agt.executablesPaneContent action="viewAgentExecutableJobs" selector="#Executablejobs" id=agentId/]
        [/@dj.contentPane]

        [@dj.contentPane labelKey='agent.environments.execute']
            [@agt.executablesPaneContent action="viewAgentExecutableDeployments" selector="#Executabledeploymentenvironments" id=agentId/]
        [/@dj.contentPane]
    [#break]

    [/#switch]

    [@dj.contentPane labelKey='system.info.title']
        [@agt.systemInfoAgent systemInfo=systemInfo /]
    [/@dj.contentPane]

    [@dj.contentPane labelKey='auditlog.agent']
    	[@cp.configChangeHistory pager=pager /]
    [/@dj.contentPane]

    [@dj.contentPane labelKey='system.errors.title']
			[#assign numErrors = systemErrorMessages.size()]
			<p>
			    [@ww.text name='system.errors.description']
			        [@ww.param value=numErrors /]
			    [/@ww.text]
			</p>

			[#if numErrors gt 0]
			    [#list systemErrorMessages as error]
			        [@cp.showSystemError error=error returnUrl=currentUrl webPanelLocation='agent.errors'/]
			    [/#list]
			[/#if]
    [/@dj.contentPane]

[/@dj.tabContainer]

</body>
</html>
