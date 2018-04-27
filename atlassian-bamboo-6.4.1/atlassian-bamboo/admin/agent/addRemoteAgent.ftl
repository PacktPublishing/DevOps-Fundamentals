[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.AddRemoteAgent" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.AddRemoteAgent" --]
<html>
<head>
    <title>[@s.text name='agent.remote.add' /]</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="agentsConfig">
    <style type="text/css">
        #remoteAgentHelp em{
            color: green;
        }
    </style>
</head>

<body>

    <!-- Agent installation -->
    <h1>[@s.text name='agent.remote.add.heading' /]</h1>

    [@s.text name='agent.remote.add.description'/]

    <p class="fullyCentered"><a href="${req.contextPath}/agentServer/agentInstaller/atlassian-bamboo-agent-installer-${buildUtils.getCurrentVersion()}.jar"><img src="${req.contextPath}/images/download_remote_agent_button.png" alt="Download"/></a></p>

    <h1>[@s.text name='agent.remote.run.heading' /]</h1>

    <div id="remoteAgentHelp">
        <p>[@s.text name="agent.remote.run.description.part.1"/]</p>

        <code>[@cp.startAgentCommand baseUrl=baseUrl
                    securityTokenRequired=securityTokenRequired
                    securityToken=securityToken /]</code>

        <p>
            [@s.text name="agent.remote.run.description.part.2"]
                [@s.param][@help.href pageKey="agent.remote.installation"/][/@s.param]
            [/@s.text]
        </p>

        [#if baseUrl?starts_with("https:")]
            <h3>[@s.text name='agent.remote.run.ssl.warning.header'/]</h3>
            <p>[@s.text name='agent.remote.run.ssl.warning.body'/]</p>
            <ul>
                <li>
                    [#assign systemProperty='-Dbamboo.agent.ignoreServerCertName=true'/]
                    [@s.text name='agent.remote.run.ssl.warning.option.1']
                        [@s.param]${systemProperty}[/@s.param]
                        [@s.param][@cp.startAgentCommand baseUrl=baseUrl
                                        systemProperties=systemProperty
                                        securityTokenRequired=securityTokenRequired
                                        securityToken=securityToken /][/@s.param]
                    [/@s.text]
                </li>
                <li>[@s.text name='agent.remote.run.ssl.warning.option.2'/]</li>
            </ul>
        [/#if]

        <h3>[@s.text name='agent.remote.run.legacy.title' /]</h3>
        <p>
            [@s.text name='agent.remote.run.legacy.description']
                [@s.param]${buildUtils.getCurrentVersion()}[/@s.param]
                [@s.param][@help.href pageKey="agent.remote.installation.jaronly"/][/@s.param]
            [/@s.text]
        </p>
    </div>

</body>
</html>