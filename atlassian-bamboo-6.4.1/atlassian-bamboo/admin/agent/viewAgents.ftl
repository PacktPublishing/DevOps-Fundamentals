[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureAgents" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureAgents" --]

[#import "/agent/commonAgentFunctions.ftl" as agt]

<html>
<head>
    <title>[@s.text name='agent.title' /]</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="agentsConfig">
</head>

<body>
    [#if featureManager.localAgentsSupported || featureManager.remoteAgentsSupported]
        <div class="toolbar agents-toolbar">
            <div class="aui-toolbar inline">
                <ul class="toolbar-group">
                    [#if fn.hasGlobalAdminPermission() && featureManager.localAgentsSupported]
                        [#if allowNewLocalAgent]
                        <li class="toolbar-item">
                            <a class="toolbar-trigger" href="[@s.url action='addLocalAgent' namespace='/admin/agent' /]">[@s.text name='agent.local.add' /]</a>
                        </li>
                        [/#if]
                    [/#if]
                    [#if featureManager.remoteAgentsSupported && allowedNumberOfRemoteAgents != 0]
                        [#if remoteAgentFunctionEnabled]
                            [#if featureManager.remoteAgentsManagementEnabled]
                                [#if !remoteAgentAuthenticationEnabled]
                                    <li class="toolbar-item">
                                        <a class="toolbar-trigger mutative" id="enableRemoteAgentAuthentication" data-action="control-remote-agent-authentication"
                                           href="[@s.url action='enableRemoteAgentAuthentication' namespace='/admin/agent' /]">[@s.text name='agent.remote.authentication.enable' /]</a>
                                    </li>
                                [/#if]
                                [#if !securityTokenRequiredFromAgents]
                                    <li class="toolbar-item">
                                        <a class="toolbar-trigger mutative" id="enableRemoteAgentTokenVerification" data-action="control-remote-agent-security-token"
                                                href="[@s.url action='enableRemoteAgentTokenVerification' namespace='/admin/agent' /]">[@s.text name='agent.remote.securityToken.enable' /]</a>
                                    </li>
                                [/#if]
                            [/#if]
                            [#if fn.hasAdminPermission()]
                                <li class="toolbar-item">
                                    <a class="toolbar-trigger" href="[@s.url action='addRemoteAgent' namespace='/admin/agent' /]">[@s.text name='agent.remote.add' /]</a>
                                </li>
                            [/#if]
                        [#else]
                             <li class="toolbar-item">
                                 <a class="toolbar-trigger mutative" id="enableRemoteAgentFunction" href="[@s.url action='enableRemoteAgentFunction' namespace='/admin/agent' /]">[@s.text name='agent.remote.enableFunction' /]</a>
                             </li>
                        [/#if]
                    [/#if]
                </ul>
            </div>
        </div>
    [/#if]
    <h1>[@s.text name='agent.heading' /]</h1>

    <p>[@s.text name='agent.description']
        [@s.param]${req.contextPath}/admin/agent/viewAgentPlanMatrixWizard.action[/@s.param]
    [/@s.text]</p>

    [#if featureManager.remoteAgentsSupported && allowedNumberOfRemoteAgents != 0 && !remoteAgentFunctionEnabled]
        [@ui.messageBox type="warning"][@s.text name="agent.remote.functionDisabled"][@s.param][@help.href pageKey="agent.remote.security"/][/@s.param][/@s.text][/@ui.messageBox]
    [/#if]

    [@s.actionerror /]
    [@ui.actionwarning /]
    [@s.actionmessage /]

    [#if (fn.hasGlobalAdminPermission())]
        [#assign sharedCapabilitiesLink]
            <a href="${req.contextPath}/admin/agent/configureSharedLocalCapabilities.action">${action.getText("agent.capability.shared.local.title")}</a>
        [/#assign]
    [#else]
        [#assign sharedCapabilitiesLink='']
    [/#if]

    [#if featureManager.localAgentsSupported]
        [@ui.bambooPanel titleKey='agent.local.heading' descriptionKey='agent.local.description' tools=sharedCapabilitiesLink]
            [#if localAgents?has_content]
                [@s.form action="configureAgents!reconfigure.action" id="localAgentConfiguration" theme="simple"]
                [@agt.displayOperationsHeader agentType='Local'/]
                    [#if !allowNewLocalAgent]
                        [@s.text name='agent.local.limited.description']
                            [@s.param value=allowedNumberOfLocalAgents /]
                        [/@s.text]
                    [/#if]
                    <table id="local-agents" class="aui">
                        <colgroup>
                            <col width="5" />
                            <col />
                            <col width="185" />
                            <col width="95" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>&nbsp;</th>
                                <th>[@s.text name='agent.table.heading.name' /]</th>
                                <th>[@s.text name='agent.table.heading.status' /]</th>
                                <th>[@s.text name='agent.table.heading.operations' /]</th>
                            </tr>
                        </thead>
                        <tbody>
                            [#foreach agent in localAgents]
                                <tr>
                                    <td><input name="selectedAgents" type="checkbox" value="${agent.id}" class="selectorAgentType_Local selectorAgentEnabled_${agent.enabled?string} selectorAgentStatus_${agent.agentStatus}" /></td>
                                    <td>[@ui.renderAgentNameAdminLink agent /]</td>
                                    <td>[@agt.displayStatusCell agent=agent /]</td>
                                    <td>[@agt.displayOperationsCell agent=agent /]</td>
                                </tr>
                            [/#foreach]
                        </tbody>
                    </table>
                [/@s.form]
            [#else]
                [@s.text name='agent.local.none' /]
            [/#if]
        [/@ui.bambooPanel]
    [#else]
        [@ui.messageBox type="info" titleKey="local.agents.not.supported.for.ondemand"/]
    [/#if]

    [#if featureManager.remoteAgentsSupported]
        [#if allowedNumberOfRemoteAgents != 0]
            [#if remoteAgentFunctionEnabled]
                [#assign configSharedRemoteLink]
                    <a id="sharedRemoteCapabilities" href="[@s.url action="configureSharedRemoteCapabilities" namespace="/admin/agent" /]">[@s.text name="agent.capability.shared.remote.title" /]</a>
                [/#assign]
                [#assign remoteAgentToolItems="${configSharedRemoteLink}" /]
                [#if featureManager.remoteAgentsManagementEnabled]
                    [#assign disableRemoteLink]
                        <a id="disableRemoteAgentFunction" href="[@s.url action="disableRemoteAgentFunction" namespace="/admin/agent" /]">[@s.text name="agent.remote.disableFunction" /]</a>
                    [/#assign]
                    [#assign remoteAgentToolItems="${remoteAgentToolItems} | ${disableRemoteLink}" /]
                [/#if]
                [#if remoteAgentAuthenticationEnabled && featureManager.remoteAgentsManagementEnabled]
                    [#assign disableRemoteAuthenticationLink]
                    <a id="disableRemoteAgentAuthentication" data-action="control-remote-agent-authentication"
                            href="[@s.url action="disableRemoteAgentAuthentication" namespace="/admin/agent" /]">[@s.text name="agent.remote.authentication.disable" /]</a>
                    [/#assign]
                    [#assign remoteAgentToolItems="${remoteAgentToolItems} | ${disableRemoteAuthenticationLink}" /]
                [/#if]
                [#if securityTokenRequiredFromAgents && featureManager.remoteAgentsManagementEnabled]
                    [#assign disableSecurityTokenLink]
                    <a id="disableRemoteAgentTokenVerification" data-action="control-remote-agent-security-token"
                            href="[@s.url action="disableRemoteAgentTokenVerification" namespace="/admin/agent" /]">[@s.text name="agent.remote.securityToken.disable" /]</a>
                    [/#assign]
                    [#assign remoteAgentToolItems="${remoteAgentToolItems} | ${disableSecurityTokenLink}" /]
                [/#if]

                [@ui.bambooPanel
                    titleKey='agent.remote.heading'
                    descriptionKey='agent.remote.description'
                    tools="${remoteAgentToolItems}"
                ]

                    [#assign tabs=['agent.remote.online.tab', 'agent.remote.offline.tab'] /]
                    [#if remoteAgentAuthenticationEnabled]
                        [#assign tabs=[tabs[0], tabs[1], 'agent.remote.authentication.tab'] /]
                    [/#if]
                    [@dj.tabContainer headingKeys=tabs selectedTab=action.selectedTab! tabViewId="remote-agents-tabs"]
                        [@dj.contentPane labelKey='agent.remote.online.tab' ]
                            [@agt.onlineAgents /]
                        [/@dj.contentPane]
                        [@dj.contentPane labelKey='agent.remote.offline.tab']
                            [@agt.offlineAgents/]
                        [/@dj.contentPane]
                        [#if remoteAgentAuthenticationEnabled]
                            [@dj.contentPane labelKey='agent.remote.authentication.tab']
                                [@agt.remoteAgentAuthentications /]
                            [/@dj.contentPane]
                        [/#if]
                    [/@dj.tabContainer]
                [/@ui.bambooPanel]
            [/#if]
        [/#if]
    [#else]
        [@ui.messageBox type="info" titleKey="remote.agents.not.supported.for.ondemand"/]
    [/#if]

    [#if featureManager.remoteAgentsSupported]
        [@dj.simpleDialogForm triggerSelector="a[data-action=control-remote-agent-authentication]"
            headerKey="agent.remote.authentication" submitCallback="reloadThePage" /]
        [@dj.simpleDialogForm triggerSelector="a[data-action=control-remote-agent-security-token]"
            headerKey="agent.remote.securityToken" submitCallback="reloadThePage" /]
    [/#if]

</body>
</html>