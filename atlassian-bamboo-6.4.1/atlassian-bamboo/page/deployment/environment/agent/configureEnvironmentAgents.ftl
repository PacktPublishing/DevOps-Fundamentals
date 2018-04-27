[#-- @ftlvariable name="action" type="com.atlassian.bamboo.deployments.environments.actions.agents.ConfigureEnvironmentAgents" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.deployments.environments.actions.agents.ConfigureEnvironmentAgents" --]
[#import "/fragments/variable/variables.ftl" as variables/]

[#assign headerText][@ww.text name="deployment.environment.agents"]
    [@ww.param]${environment.name}[/@ww.param]
[/@ww.text][/#assign]

<html>
<head>
[@ui.header page=headerText title=true/]
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>
[#if action.hasActionErrors()]
    [#list formattedActionErrors as error]
        [@ui.messageBox type="error"]${error}[/@ui.messageBox]
    [/#list]
[#else ]
    [#assign headerText]
        [@ww.text name="deployment.project.environment.agents.assignment.title"]
            [@ww.param value=environment.name /]
        [/@ww.text]
    [/#assign]
    [@ui.header page=headerText headerElement="h2"/]
    <div id="requirements-summary"></div>
    <div id="environment-requirements"></div>
        [#assign agentsSectionDescription]
            [@s.text name="deployments.assigned.agents.howtheywork.text"/] [@help.url pageKey="deployments.assigned.agents.howtheywork"][@s.text name="deployments.assigned.agents.howtheywork.link"/][/@help.url]
        [/#assign]
        [@ui.bambooSection titleKey='deployment.project.environment.agents.title' description=agentsSectionDescription collapsible=true isCollapsed=!action.hasDedicatedAgents()]
        <p>[@ww.text name="deployment.environment.agents.description"][@ww.param][@help.href pageKey='capabilities.and.requirements'/][/@ww.param][/@ww.text]</p>
        <p>[@ww.text name="deployment.environment.agents.description.note"/]</p>

        [#--don't remove this field. It's used by page/environment-agents/environment-agent-assignment-table-edit-row to pass environmentId--]
        [@ww.hidden name="environmentId"/]

        <div id="agent-assignments"></div>
        [/@ui.bambooSection]

    <script type="text/javascript">
        require(['page/environment-agents/environment-agents'], function(EnvironmentAgents){
            new EnvironmentAgents({
                requirementsEl: '#environment-requirements',
                agentsAssignmentEl: '#agent-assignments',
                summaryEl: '#requirements-summary',
                environmentId: '${environmentId}'
            }).start();
        });
    </script>
    <div class="aui-toolbar inline environment-back-button environment-agents-back-button">
        <ul class="toolbar-group">
            <li class="toolbar-item">
                <a id="backToDeploymentProject" href="${req.contextPath}/deploy/config/configureDeploymentProject.action?id=${deploymentProject.id}&environmentId=${environment.id}" class="aui-button toolbar-trigger">
                    [@ww.text name="deployment.environment.back" /]
                </a>
            </li>
        </ul>
    </div>
[/#if]

</body>
</html>