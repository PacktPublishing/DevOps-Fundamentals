[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticImageConfigurationAssignments" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticImageConfigurationAssignments" --]
<html>
<head>
    <title>[@s.text name='agents.assignment.image.title' /] - ${image.configurationName?html}</title>
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="viewElasticImageConfigurations">
</head>

<body>
<h1>[@s.text name='agents.assignment.image.title' /] - ${image.configurationName?html}</h1>

<p>[@s.text name='agents.assignment.image.description' /]</p>

[@ww.hidden name='configurationId' /]

<table class="aui agent-assignments">
    <thead>
    <tr>
        <th>[@s.text name='agents.assignment.agent.type'/]</th>
        <th>[@s.text name='agents.assignment.agent.entity.name'/]</th>
        <th></th>
    </tr>
    </thead>
    <tr>
        <td class="agent-assignment-type">
            <select id="assignmentTypeTextField" data-placeholder="[@s.text name='agents.assignment.type.hint'/]">
                <option></option>
            [#list assignmentTypes as type]
                <option value="${type.name()}">${type.value}</option>
            [/#list]
            </select>
        </td>
        <td class="agent-assignment-name">
            <input type="text"
                    id="addEntityTextField"
                    name="addEntityTextField"
                    class="text long-field "
                    placeholder="[@s.text name='agents.assignment.agent.hint'/]">
        </td>
        <td class="agent-assignment-operations">
            <input id="addAgentAssignmentButton" class="aui-button aui-button-primary" type="button" value="Add"/>
        </td>
    </tr>
    <tbody class="selected-env-assignments"></tbody>
</table>
[@ui.displayFieldGroup]
        [#assign capabilitiesTooltipUrl="/ajax/viewRejectedRequirements.action?imageConfigurationId=${image.id}" /]
        <script type="text/javascript">
            require(['jquery', 'feature/agent-assignment'], function($, AgentAssignment){
                return new AgentAssignment({
                    el: $('#addEntityTextField'),
                    typeSelector: '#assignmentTypeTextField',
                    addButton: $('#addAgentAssignmentButton'),
                    selectedAssignmentsEl: $('.selected-env-assignments'),
                    capabilitiesTooltipUrl: '${capabilitiesTooltipUrl}',
                    assignmentsBaseUrl: '/rest/api/latest/agent/assignment',
                    agentId: ${configurationId},
                    executableType: 'IMAGE'
                });
            });
        </script>
[/@ui.displayFieldGroup]

</body>
</html>