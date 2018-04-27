[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ControlRemoteAgentsTokenVerification" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ControlRemoteAgentsTokenVerification" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]

<html>
    <head>
        [@ui.header pageKey="agent.remote.securityToken.enable" title=true /]
        <meta name="decorator" content="adminpage">
        <meta name="adminCrumb" content="agentsConfig">
    </head>
    <body>
        [@s.form
            id='confirmAgentSecurityTokenForm'
            action='enableRemoteAgentTokenVerification' namespace='/admin/agent'
            submitLabelKey='global.buttons.enable'
            cancelUri='/admin/agent/viewAgents.action']

            <h3>[@s.text name='agent.remote.securityToken.enable.confirmation.title' /]</h3>

            <p>[@s.text name='agent.remote.securityToken.enable.confirmation.1' /]</p>
            <p>
                [@s.text name='agent.remote.securityToken.enable.confirmation.2']
                    [@s.param]${req.contextPath}/admin/agent/addRemoteAgent.action[/@s.param]
                [/@s.text]
            </p>
            <p>
                [@s.text name='agent.remote.securityToken.moreInformation']
                    [@s.param][@help.href pageKey="agent.remote.authentication.docs"/][/@s.param]
                [/@s.text]
            </p>

            [@s.hidden name='confirmed' value=true /]
        [/@s.form]
    </body>
</html>
