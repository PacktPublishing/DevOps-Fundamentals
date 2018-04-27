[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.SelectAgentsAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.SelectAgentsAction" --]
<html>
<head>
    <title>[@s.text name='dashboard.selectAgents.tracker.configure' /]</title>
    <meta name="bodyClass" content="aui-page-focused agents-wizard--focused"/>
    <meta name="decorator" content="agentsWizard"/>
    <meta name="tab" content="0"/>
</head>
<body>

<h2>[@s.text name='dashboard.setupRemoteAgent.title' /]</h2>
<div class="agents-wizard__content">
    <div class="agents-wizard__main-content">
        <p>[@s.text name='dashboard.setupRemoteAgent.description' ]
            [@s.param][@help.href pageKey="cloud.remote.agent.first.setup" /][/@s.param]
        [/@s.text]</p>

        [#-- Step 1: Download --]
        <h3>[@s.text name='dashboard.setupRemoteAgent.tab1.header1' /]</h3>
        <p>[@s.text name='dashboard.setupRemoteAgent.tab1.description1' /]</p>
        <div class="agents-wizard__highlight">
            <a href="${req.contextPath}/agentServer/agentInstaller/atlassian-bamboo-agent-installer-${buildUtils.getCurrentVersion()}.jar" class="aui-button aui-button-primary agents-wizard__button--download">[@s.text name='dashboard.setupRemoteAgent.download' /]<span>v ${buildUtils.getCurrentVersion()}</span></a>
        </div>

        [#-- Step 2: Run --]
        <h3>[@s.text name='dashboard.setupRemoteAgent.tab1.header2' /]</h3>
        <p>
            [@s.text name='dashboard.setupRemoteAgent.tab1.description2.part1' ]
                [@s.param]http://www.oracle.com/technetwork/java/javase/downloads/index.html[/@s.param]
                [@s.param][@help.href pageKey="cloud.remote.agent.supported.platforms" /][/@s.param]
            [/@s.text]
        </p>
        <p>[@s.text name='dashboard.setupRemoteAgent.tab1.description2.part2' /]</p>
        <div class="agents-wizard__highlight agents-wizard__highlight--code">
            <pre>[@cp.startAgentCommand baseUrl=baseUrl
                        highlightJarFile=true
                        securityTokenRequired=securityTokenRequired
                        securityToken=securityToken /]</pre>
        </div>
        <p>
            [@s.text name='dashboard.setupRemoteAgent.tab1.description2.part3' ]
                [@s.param][@help.href pageKey="agent.remote.installation" /][/@s.param]
            [/@s.text]
        </p>

        [#-- Step 3: Authenticate --]
        <h3>[@s.text name='dashboard.setupRemoteAgent.tab1.header3' /]</h3>
        <p>[@s.text name='dashboard.setupRemoteAgent.tab1.description3']
            [@s.param][@help.href pageKey="cloud.remote.agent.troubleshooting" /][/@s.param]
        [/@s.text]</p>
    </div>
    ${soy.render("aui.buttons.button", {
        'text': '${i18n.getText("dashboard.setupRemoteAgent.goBack")}',
        'href': 'selectAgents.action'
    })}
    ${soy.render("aui.buttons.button", {
        'text': '${i18n.getText("dashboard.setupRemoteAgent.authenticate")}',
        'extraClasses': 'agents-wizard__button',
        'type': 'primary'
    })}
</div>
[#assign firstRemoteAgentSetupHelpLink = ctx.helpLink.getUrl('cloud.remote.agent.troubleshooting')]
<script type="application/javascript">
    require([
        'jquery',
        'feature/agents-wizard/dialog-authenticate-agents'
    ], function(
        $,
        AuthenticateAgentsDialog
    ){
        return new AuthenticateAgentsDialog({
            $triggerEl: $('.agents-wizard__button'),
            firstRemoteAgentSetupHelpLink: '${firstRemoteAgentSetupHelpLink}'
        });
    });
</script>

</body>
</html>