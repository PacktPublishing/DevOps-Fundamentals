[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewAgent" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewAgent" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
<html>
<head>
    <title>
    [@s.text name='agent.view.heading.' + agent.type.identifier /]
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
    <meta name="decorator" content="bamboo.agent"/>
    <meta name="tab" content="execute" />
</head>
<body>

[@ui.header pageKey='agent.environments.execute' /]
[@agt.executableEnvironments environmentList=executableEnvironments /]

</body>
</html>