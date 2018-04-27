[#-- @ftlvariable name="action" type="com.atlassian.bamboo.agent.AgentConsoleAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.agent.AgentConsoleAction" --]

[#assign title]
    [@s.text name="agent.shell.session"][@s.param value=agentName/][/@s.text]
[/#assign]
<html>
<head>
    <title>${title?html}</title>
    ${webResourceManager.requireResource("bamboo.web.resources:agentConsole")}
</head>
<body>
<h1>${title?html}</h1>

<div id="terminalWindow"></div>

<script type="text/javascript">
    require(['jquery', 'widget/agent-console'], function($, AgentConsole){
        $(function(){
            new AgentConsole({
                el: $('#terminalWindow'),
                agentId: ${agentId},
                permissionPlanKey: '${planKey}'
            });
        });
    });
</script>
</body>
</html>
